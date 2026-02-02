--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                
    🐺 LXR Lottery System - Server Script
    
    Handles server-side lottery logic including database operations, winner selection,
    money transactions, and security validation. Uses framework adapter for compatibility.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

-- Wait for framework to initialize
while not Framework or not Framework.Active do
    Wait(100)
end

if Config.Debug then
    print('[LXR-Lottery] Server initialized with framework: ' .. Framework.Active)
end

-- Framework-specific resources
local VORPcore
if Framework.Active == 'vorp_core' then
    VORPcore = exports.vorp_core:GetCore()
end

-- State tracking
local jackpot = 'pricemoney'
local counter = nil
local timeleft = 0
local locale = Config.Locale[Config.Lang] or Config.Locale['en']

-- Security tracking
local purchaseCooldowns = {}
local purchaseCounters = {}

-- ════════════════════════════════════════════════════════════════════════════════
-- VERSION CHECKER
-- ════════════════════════════════════════════════════════════════════════════════

local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'
    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    -- Updated to check LXR version
    PerformHttpRequest('https://raw.githubusercontent.com/iboss21/lxr-lottery/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TIMER SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Load timer from database
    local Timer = MySQL.query.await("SELECT * FROM " .. Config.DatabaseTables.timer, {})
    if #Timer > 0 then
        counter = Timer[1].timer
    else
        counter = Config.Winner.pickTimeMinutes * 60
        MySQL.insert('INSERT INTO `' .. Config.DatabaseTables.timer .. '` (timer) VALUES (?)',
            {counter}, function() end)
    end
    
    Wait(500)
    
    local lastDbSync = os.time()
    
    -- Main timer loop
    while counter ~= nil do
        Wait(Config.Performance.updateInterval or 2000)
        
        counter = counter - 2
        timeleft = counter / 60
        
        -- Sync to database every 30 seconds (not every 2 seconds for performance)
        if os.time() - lastDbSync >= 30 then
            local OldTimer = MySQL.query.await("SELECT * FROM " .. Config.DatabaseTables.timer, {})
            if #OldTimer > 0 then
                local newcounter = counter
                if newcounter < 0 then
                    newcounter = 0
                end
                MySQL.update('UPDATE `' .. Config.DatabaseTables.timer .. '` SET timer = ?', {newcounter})
            end
            lastDbSync = os.time()
        end
        
        -- Update all players with timer
        for _, player in ipairs(GetPlayers()) do
            TriggerClientEvent('mms-lottery:client:updatetimer', player, timeleft)
        end
        
        -- Check for winner selection
        if counter <= 0 then
            TriggerEvent('mms-lottery:server:pickwinner')
            counter = Config.Winner.pickTimeMinutes * 60
            
            -- Update database
            MySQL.update('UPDATE `' .. Config.DatabaseTables.timer .. '` SET timer = ?', {counter})
            lastDbSync = os.time()
            timeleft = 0
            Wait(500)
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- WINNER SELECTION
-- ════════════════════════════════════════════════════════════════════════════════

RegisterServerEvent('mms-lottery:server:pickwinner')
AddEventHandler('mms-lottery:server:pickwinner', function()
    MySQL.query('SELECT * FROM ' .. Config.DatabaseTables.tickets, {}, function(result)
        if result and #result > 0 then
            -- Winner exists
            local winner = {}
            
            for _, v in ipairs(result) do
                table.insert(winner, v.id)
            end
            
            local randomwinner = math.random(1, #winner)
            local winnerticketid = winner[randomwinner]
            
            if Config.Debug then
                print('[LXR-Lottery] Winner ticket ID: ' .. winnerticketid)
            end
            
            TriggerEvent('mms-lottery:server:winner', winnerticketid)
        else
            -- No winner (no tickets sold)
            if Config.Winner.announceIfNoWinner then
                for _, player in ipairs(GetPlayers()) do
                    Framework.Notify(player, locale.NoTicketsBought, 10000, 'inform')
                end
            end
            
            if Config.Webhook.enabled then
                Framework.SendWebhook(
                    Config.Webhook.titleNoWinner, 
                    locale.NoTicketsBought, 
                    Config.Webhook.colorNoWinner
                )
            end
        end
    end)
end)

RegisterServerEvent('mms-lottery:server:winner')
AddEventHandler('mms-lottery:server:winner', function(winnerticketid)
    local winnerfirstname, winnerlastname, winneridentifier, winnerpricemoney
    
    MySQL.query('SELECT * FROM ' .. Config.DatabaseTables.tickets .. ' WHERE id = ?', {winnerticketid}, function(result)
        if result and result[1] then
            winnerfirstname = result[1].firstname
            winnerlastname = result[1].lastname
            winneridentifier = result[1].identifier
        end
    end)
    
    MySQL.query('SELECT * FROM ' .. Config.DatabaseTables.jackpot, {}, function(result)
        if result and result[1] then
            winnerpricemoney = result[1].money
        end
    end)
    
    Wait(2000) -- Wait for queries to complete
    
    TriggerEvent('mms-lottery:server:insertwinner', winnerfirstname, winneridentifier, winnerlastname, winnerpricemoney)
end)

RegisterServerEvent('mms-lottery:server:insertwinner')
AddEventHandler('mms-lottery:server:insertwinner', function(winnerfirstname, winneridentifier, winnerlastname, winnerpricemoney)
    -- Send Discord webhook
    if Config.Webhook.enabled then
        local message = locale.TheWinnerIs .. winnerfirstname .. ' ' .. winnerlastname .. locale.HeWins .. winnerpricemoney
        Framework.SendWebhook(Config.Webhook.titleWinner, message, Config.Webhook.colorWinner)
    end
    
    -- Announce to players
    if Config.Winner.announceWinner then
        for _, player in ipairs(GetPlayers()) do
            Framework.Notify(
                player, 
                locale.TheWinnerIs .. winnerfirstname .. ' ' .. winnerlastname .. locale.HeWins .. winnerpricemoney,
                10000,
                'success'
            )
        end
    else
        -- Announce that lottery is over without winner details
        for _, player in ipairs(GetPlayers()) do
            Framework.Notify(player, locale.LotteryOver, 10000, 'inform')
        end
    end
    
    -- Insert winner record
    MySQL.insert(
        'INSERT INTO `' .. Config.DatabaseTables.winners .. '` (firstname, lastname, identifier, pricemoney) VALUES (?, ?, ?, ?)', 
        {winnerfirstname, winnerlastname, winneridentifier, winnerpricemoney}, 
        function() end
    )
    
    -- Clear lottery data
    TriggerEvent('mms-lottery:server:clear')
end)

RegisterServerEvent('mms-lottery:server:clear')
AddEventHandler('mms-lottery:server:clear', function()
    MySQL.execute('DELETE FROM ' .. Config.DatabaseTables.tickets, {}, function() end)
    MySQL.execute('DELETE FROM ' .. Config.DatabaseTables.jackpot, {}, function() end)
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- CALLBACK REGISTRATION (VORP Compatibility)
-- ════════════════════════════════════════════════════════════════════════════════

if Framework.Active == 'vorp_core' and VORPcore then
    VORPcore.Callback.Register('mms-banking:callback:getplayermoney', function(source, cb)
        local money = Framework.GetPlayerMoney(source)
        cb(money)
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TICKET PURCHASE (With Security Features)
-- ════════════════════════════════════════════════════════════════════════════════

RegisterServerEvent('mms-lottery:server:buyticket')
AddEventHandler('mms-lottery:server:buyticket', function()
    local src = source
    
    -- Get player data via framework adapter
    local identifier = Framework.GetPlayerIdentifier(src)
    local firstname = Framework.GetPlayerFirstName(src)
    local lastname = Framework.GetPlayerLastName(src)
    local money = Framework.GetPlayerMoney(src)
    
    if not identifier then
        if Config.Debug then
            print('[LXR-Lottery] ERROR: Could not get player identifier for source: ' .. src)
        end
        return
    end
    
    -- Security: Rate limiting
    if Config.Security.enabled and Config.Security.cooldownBetweenPurchases > 0 then
        local lastPurchase = purchaseCooldowns[identifier]
        if lastPurchase then
            local timeSince = (os.time() * 1000) - lastPurchase
            if timeSince < Config.Security.cooldownBetweenPurchases then
                Framework.Notify(src, 'Please wait before purchasing another ticket', 3000, 'error')
                return
            end
        end
    end
    
    -- Security: Money validation
    if Config.Security.enabled and Config.Security.validateMoney then
        if money < Config.Tickets.price then
            Framework.Notify(src, locale.NotEnoghMoney, 5000, 'error')
            return
        end
    end
    
    -- Random wait to prevent spam (250-500ms)
    local randomwait = math.random(250, 500)
    Wait(randomwait)
    
    -- Check ticket limits
    if Config.Tickets.limitEnabled then
        MySQL.query('SELECT * FROM `' .. Config.DatabaseTables.tickets .. '` WHERE identifier = ?', {identifier}, function(result)
            if result[1] ~= nil then
                -- Player has existing tickets
                if result[1].tickets < Config.Tickets.maxPerPlayer then
                    -- Can buy more
                    local newtickets = result[1].tickets + 1
                    
                    -- Remove money
                    if Framework.RemoveMoney(src, Config.Tickets.price) then
                        -- Update ticket count
                        MySQL.update('UPDATE `' .. Config.DatabaseTables.tickets .. '` SET tickets = ? WHERE identifier = ?', {newtickets, identifier})
                        Framework.Notify(src, locale.TicketBought .. Config.Tickets.price, 5000, 'success')
                        
                        -- Update jackpot
                        UpdateJackpot(Config.Tickets.price)
                        
                        -- Set cooldown
                        purchaseCooldowns[identifier] = os.time() * 1000
                    else
                        Framework.Notify(src, locale.NotEnoghMoney, 5000, 'error')
                    end
                else
                    -- At ticket limit
                    Framework.Notify(src, locale.MaxTicketsBought .. Config.Tickets.maxPerPlayer, 5000, 'error')
                end
            else
                -- First ticket purchase
                if Framework.RemoveMoney(src, Config.Tickets.price) then
                    MySQL.insert('INSERT INTO `' .. Config.DatabaseTables.tickets .. '` (firstname, lastname, identifier, tickets) VALUES (?, ?, ?, ?)', 
                        {firstname, lastname, identifier, 1}, function() end)
                    Framework.Notify(src, locale.TicketBought .. Config.Tickets.price, 5000, 'success')
                    
                    -- Update jackpot
                    UpdateJackpot(Config.Tickets.price)
                    
                    -- Set cooldown
                    purchaseCooldowns[identifier] = os.time() * 1000
                else
                    Framework.Notify(src, locale.NotEnoghMoney, 5000, 'error')
                end
            end
        end)
    else
        -- No ticket limits
        if Framework.RemoveMoney(src, Config.Tickets.price) then
            MySQL.insert('INSERT INTO `' .. Config.DatabaseTables.tickets .. '` (firstname, lastname, identifier) VALUES (?, ?, ?)', 
                {firstname, lastname, identifier}, function() end)
            Framework.Notify(src, locale.TicketBought .. Config.Tickets.price, 5000, 'success')
            
            -- Update jackpot
            UpdateJackpot(Config.Tickets.price)
            
            -- Set cooldown
            purchaseCooldowns[identifier] = os.time() * 1000
        else
            Framework.Notify(src, locale.NotEnoghMoney, 5000, 'error')
        end
    end
end)

-- Helper function to update jackpot
function UpdateJackpot(amount)
    MySQL.query('SELECT `money` FROM `' .. Config.DatabaseTables.jackpot .. '` WHERE jackpot = ?', {jackpot}, function(result)
        if result[1] ~= nil then
            local money = result[1].money
            local newmoney = money + amount
            MySQL.update('UPDATE `' .. Config.DatabaseTables.jackpot .. '` SET money = ? WHERE jackpot = ?', {newmoney, jackpot})
        else
            -- First jackpot entry
            local firstmoney = amount
            if Config.Jackpot.useStartAmount then
                firstmoney = firstmoney + Config.Jackpot.startAmount
            end
            MySQL.insert('INSERT INTO `' .. Config.DatabaseTables.jackpot .. '` (jackpot, money) VALUES (?, ?)', 
                {jackpot, firstmoney}, function() end)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- JACKPOT UPDATE SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(Config.Performance.updateInterval or 2000)
        
        MySQL.query('SELECT `money` FROM `' .. Config.DatabaseTables.jackpot .. '` WHERE jackpot = ?', {jackpot}, function(result)
            local jackpotmoney = 0
            if result[1] ~= nil then
                jackpotmoney = result[1].money
            end
            
            -- Update all players
            for _, player in ipairs(GetPlayers()) do
                TriggerClientEvent('mms-lottery:client:updatejackpot', player, jackpotmoney)
            end
        end)
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- WINNINGS CLAIM
-- ════════════════════════════════════════════════════════════════════════════════

RegisterServerEvent('mms-lottery:server:getwinnings')
AddEventHandler('mms-lottery:server:getwinnings', function()
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    
    if not identifier then
        Framework.Notify(src, 'Unable to identify player', 5000, 'error')
        return
    end
    
    MySQL.query('SELECT * FROM `' .. Config.DatabaseTables.winners .. '` WHERE identifier = ?', {identifier}, function(result)
        if result[1] ~= nil then
            local reward = result[1].pricemoney
            
            -- Add money via framework adapter
            if Framework.AddMoney(src, reward) then
                Framework.Notify(src, locale.WinningsGetLabel .. reward, 5000, 'success')
                
                -- Remove winner record
                MySQL.execute('DELETE FROM ' .. Config.DatabaseTables.winners .. ' WHERE identifier = ? AND pricemoney = ?', 
                    {identifier, reward}, function() end)
            else
                Framework.Notify(src, 'Failed to claim winnings, please try again', 5000, 'error')
            end
        else
            Framework.Notify(src, locale.SadNoWin, 5000, 'inform')
        end
    end)
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- VERSION CHECK & INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

CheckVersion()