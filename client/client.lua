--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                
    🐺 LXR Lottery System - Client Script
    
    Handles client-side lottery interactions including NPCs, blips, prompts, and menu system.
    Supports multiple frameworks through the framework adapter layer.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

-- Wait for framework to initialize
while not Framework or not Framework.Active do
    Wait(100)
end

-- Framework-specific resources (loaded based on detected framework)
local VORPcore, BccUtils, FeatherMenu

if Framework.Active == 'vorp_core' then
    VORPcore = exports.vorp_core:GetCore()
    BccUtils = exports['bcc-utils'].initiate()
    FeatherMenu = exports['feather-menu'].initiate()
end

-- State tracking
local CreatedBlips = {}
local CreatedNpcs = {}
local LotteryMenuOpen = false
local locale = Config.Locale[Config.Lang] or Config.Locale['en']

-- ════════════════════════════════════════════════════════════════════════════════
-- NPC & BLIP SPAWNING (Framework-Agnostic)
-- ════════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Spawn NPCs
    if Config.General.enableNPCs then
        for _, station in pairs(Config.LotteryStations) do
            local npcModel = Config.General.npcModel
            local npc = CreatePed(
                GetHashKey(npcModel),
                station.coords.x, 
                station.coords.y, 
                station.coords.z - 1,
                station.NpcHeading, 
                false, 
                false
            )
            
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(npc, true)
            
            table.insert(CreatedNpcs, npc)
        end
    end
    
    -- Spawn Blips
    if Config.General.enableBlips then
        for _, station in pairs(Config.LotteryStations) do
            local blipSprite = station.blipSprite or 'blip_shop_store'
            local blipScale = station.blipScale or 0.2
            
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.coords)
            
            -- Validate blip was created successfully before setting properties
            if blip and blip ~= 0 then
                SetBlipSprite(blip, GetHashKey(blipSprite), true)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipScale + 0.0)
                table.insert(CreatedBlips, blip)
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- INTERACTION SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

-- VORP-specific interaction (BCC Utils & Prompts)
if Framework.Active == 'vorp_core' and BccUtils then
    CreateThread(function()
        local LotteryMenuPrompt = BccUtils.Prompts:SetupPromptGroup()
        local lotteryprompt = LotteryMenuPrompt:RegisterPrompt(
            locale.PromptName, 
            0x760A9C6F, 
            1, 1, true, 
            'hold', 
            {timedeventhash = 'MEDIUM_TIMED_EVENT'}
        )
        
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, station in pairs(Config.LotteryStations) do
                local dist = #(playerCoords - station.coords)
                
                if dist < Config.General.interactionDistance then
                    sleep = 0
                    LotteryMenuPrompt:ShowGroup(locale.PromptName)
                    
                    if Config.General.show3DText then
                        BccUtils.Misc.DrawText3D(
                            station.coords.x, 
                            station.coords.y, 
                            station.coords.z, 
                            locale.TextLabel3D
                        )
                    end
                    
                    if lotteryprompt:HasCompleted() then
                        TriggerEvent('mms-lottery:client:openlottery')
                    end
                end
            end
            
            Wait(sleep)
        end
    end)
else
    -- Generic interaction system (for non-VORP frameworks)
    CreateThread(function()
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local nearLottery = false
            
            for _, station in pairs(Config.LotteryStations) do
                local dist = #(playerCoords - station.coords)
                
                if dist < Config.General.interactionDistance then
                    nearLottery = true
                    sleep = 0
                    
                    -- Draw 3D text
                    if Config.General.show3DText then
                        local onScreen, _x, _y = GetScreenCoordFromWorldCoord(
                            station.coords.x, 
                            station.coords.y, 
                            station.coords.z
                        )
                        if onScreen then
                            SetTextScale(0.35, 0.35)
                            SetTextFontForCurrentCommand(1)
                            SetTextColor(255, 255, 255, 215)
                            local str = CreateVarString(10, "LITERAL_STRING", locale.TextLabel3D)
                            SetTextCentre(1)
                            DisplayText(str, _x, _y)
                        end
                    end
                    
                    -- Check for key press (E key or configured)
                    if IsControlJustPressed(0, 0x07B8BEAF) then -- E key
                        TriggerEvent('mms-lottery:client:openlottery')
                    end
                end
            end
            
            Wait(sleep)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- MENU SYSTEM (VORP/Feather Menu)
-- ════════════════════════════════════════════════════════════════════════════════
-- Note: For other frameworks, you may need to integrate different menu systems
-- (ox_lib menu, etc.). The events below are framework-agnostic.

local LotteryMenu, LotteryMenuPage1, TextDisplay, TextDisplay2

if Framework.Active == 'vorp_core' and FeatherMenu then
    CreateThread(function()
        LotteryMenu = FeatherMenu:RegisterMenu('lotterymenu', {
            top = '20%',
            left = '20%',
            ['720width'] = '500px',
            ['1080width'] = '700px',
            ['2kwidth'] = '700px',
            ['4kwidth'] = '800px',
            style = {
                ['border'] = '5px solid orange',
                ['background-color'] = '#FF8C00'
            },
            contentslot = {
                style = {
                    ['height'] = '550px',
                    ['min-height'] = '250px'
                }
            },
            draggable = true,
        }, {
            opened = function()
                LotteryMenuOpen = true
            end,
            closed = function()
                LotteryMenuOpen = false
            end,
            topage = function(data)
                -- Page changed
            end
        })
        
        LotteryMenuPage1 = LotteryMenu:RegisterPage('seite1')
        LotteryMenuPage1:RegisterElement('header', {
            value = locale.LotteryHeader,
            slot = 'header',
            style = {
                ['color'] = 'orange',
            }
        })
        LotteryMenuPage1:RegisterElement('line', {
            slot = 'header',
            style = {
                ['color'] = 'orange',
            }
        })
        TextDisplay = LotteryMenuPage1:RegisterElement('textdisplay', {
            value = locale.NextWinnerPick,
            style = {}
        })
        TextDisplay2 = LotteryMenuPage1:RegisterElement('textdisplay', {
            value = locale.JackpotAmount .. ' 0$',
            style = {}
        })
        LotteryMenuPage1:RegisterElement('button', {
            label = locale.LabelBuyTicket .. Config.Tickets.price .. '$',
            style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
            },
        }, function()
            TriggerEvent('mms-lottery:client:buyticket')
        end)
        LotteryMenuPage1:RegisterElement('button', {
            label = locale.LabelGetWinnings,
            style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
            },
        }, function()
            TriggerEvent('mms-lottery:client:getwinnings')
        end)
        LotteryMenuPage1:RegisterElement('button', {
            label = locale.CloseLotterieMenu,
            style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
            },
        }, function()
            LotteryMenu:Close({})
        end)
        LotteryMenuPage1:RegisterElement('subheader', {
            value = locale.LotteryHeader,
            slot = 'footer',
            style = {
                ['color'] = 'orange',
            }
        })
        LotteryMenuPage1:RegisterElement('line', {
            slot = 'footer',
            style = {
                ['color'] = 'orange',
            }
        })
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- MENU OPEN EVENT
-- ════════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('mms-lottery:client:openlottery')
AddEventHandler('mms-lottery:client:openlottery', function()
    if Framework.Active == 'vorp_core' and LotteryMenu then
        LotteryMenu:Open({
            startupPage = LotteryMenuPage1,
        })
    else
        -- For other frameworks, implement menu system here
        -- Example: ox_lib menu, custom UI, etc.
        Framework.Notify('Lottery menu opening...', 3000, 'inform')
        -- TODO: Implement menu for other frameworks
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- JACKPOT & TIMER UPDATES
-- ════════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('mms-lottery:client:updatejackpot')
AddEventHandler('mms-lottery:client:updatejackpot', function(jackpotmoney)
    if LotteryMenuOpen and TextDisplay2 then
        TextDisplay2:update({
            value = locale.JackpotAmount .. jackpotmoney .. '$',
            style = {}
        })
    end
end)

RegisterNetEvent('mms-lottery:client:updatetimer')
AddEventHandler('mms-lottery:client:updatetimer', function(timeleft)
    if LotteryMenuOpen and TextDisplay then
        local round = math.floor(timeleft)
        TextDisplay:update({
            value = locale.NextWinnerPick .. round .. locale.MinuteLabel,
            style = {}
        })
    end
end)

-- Track menu state (VORP/Feather Menu specific)
if Framework.Active == 'vorp_core' then
    RegisterNetEvent('FeatherMenu:opened')
    AddEventHandler('FeatherMenu:opened', function(menudata)
        if menudata.menuid == 'lotterymenu' then
            LotteryMenuOpen = true
        end
    end)
    
    RegisterNetEvent('FeatherMenu:closed')
    AddEventHandler('FeatherMenu:closed', function(menudata)
        if menudata.menuid == 'lotterymenu' then
            LotteryMenuOpen = false
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TICKET PURCHASE
-- ════════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('mms-lottery:client:buyticket')
AddEventHandler('mms-lottery:client:buyticket', function()
    -- Get player money via callback (framework-agnostic)
    if Framework.Active == 'vorp_core' and VORPcore then
        -- VORP callback
        local Money = VORPcore.Callback.TriggerAwait('mms-banking:callback:getplayermoney')
        Wait(250)
        
        if Money >= Config.Tickets.price then
            TriggerServerEvent('mms-lottery:server:buyticket')
        else
            Framework.Notify(locale.NotEnoghMoney, 5000, 'error')
        end
    else
        -- For other frameworks, trigger server to check money
        TriggerServerEvent('mms-lottery:server:buyticket')
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- WINNINGS CLAIM
-- ════════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('mms-lottery:client:getwinnings')
AddEventHandler('mms-lottery:client:getwinnings', function()
    TriggerServerEvent('mms-lottery:server:getwinnings')
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- CLEANUP ON RESOURCE STOP
-- ════════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        -- Remove NPCs
        for _, npc in ipairs(CreatedNpcs) do
            if DoesEntityExist(npc) then
                DeleteEntity(npc)
            end
        end
        
        -- Remove Blips
        for _, blip in ipairs(CreatedBlips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
        
        -- Close menu if open
        if LotteryMenu and LotteryMenuOpen then
            LotteryMenu:Close({})
        end
    end
end)