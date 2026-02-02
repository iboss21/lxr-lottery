--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                
    🐺 Framework Adapter - Multi-Framework Bridge
    
    This adapter provides a unified interface for interacting with different RedM
    frameworks. It automatically detects the active framework and routes all calls
    to the appropriate framework-specific functions.
    
    Supported Frameworks:
    - LXR-Core (Primary)
    - RSG-Core (Primary)
    - VORP Core (Supported)
    - RedEM:RP (Optional)
    - QBR-Core (Optional)
    - QR-Core (Optional)
    - Standalone (Fallback)
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

Framework = {}
Framework.Active = nil
Framework.Core = nil

-- ════════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK DETECTION
-- ════════════════════════════════════════════════════════════════════════════════

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    -- Priority detection order
    local frameworks = {
        'lxr-core',
        'rsg-core',
        'vorp_core',
        'redem_roleplay',
        'qbr-core',
        'qr-core'
    }
    
    for _, fw in ipairs(frameworks) do
        local settings = Config.FrameworkSettings[fw]
        if settings and GetResourceState(settings.resource) == 'started' then
            return fw
        end
    end
    
    return 'standalone'
end

-- ════════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

function Framework.Init()
    Framework.Active = DetectFramework()
    local settings = Config.FrameworkSettings[Framework.Active]
    
    if Config.Debug then
        print(('[LXR-Lottery] Framework detected: %s'):format(Framework.Active))
    end
    
    -- Load framework core
    if Framework.Active == 'lxr-core' then
        Framework.Core = exports['lxr-core']:GetCoreObject()
    elseif Framework.Active == 'rsg-core' then
        Framework.Core = exports['rsg-core']:GetCoreObject()
    elseif Framework.Active == 'vorp_core' then
        Framework.Core = exports.vorp_core:GetCore()
    elseif Framework.Active == 'redem_roleplay' then
        Framework.Core = exports['redem_roleplay']:GetCoreObject()
    elseif Framework.Active == 'qbr-core' then
        Framework.Core = exports['qbr-core']:GetCoreObject()
    elseif Framework.Active == 'qr-core' then
        Framework.Core = exports['qr-core']:GetCoreObject()
    end
    
    return Framework.Active
end

-- ════════════════════════════════════════════════════════════════════════════════
-- UNIFIED NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

function Framework.Notify(source, message, duration, type)
    local settings = Config.FrameworkSettings[Framework.Active]
    duration = duration or 5000
    type = type or 'inform'
    
    if IsDuplicityVersion() then
        -- Server-side notification
        if Framework.Active == 'vorp_core' then
            Framework.Core.NotifyTip(source, message, duration)
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Lottery',
                description = message,
                type = type,
                duration = duration
            })
        elseif Framework.Active == 'standalone' then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'Lottery', message}
            })
        else
            -- Generic fallback
            TriggerClientEvent('chat:addMessage', source, {
                args = {'Lottery', message}
            })
        end
    else
        -- Client-side notification
        if Framework.Active == 'vorp_core' then
            Framework.Core.NotifyTip(message, duration)
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            exports.ox_lib:notify({
                title = 'Lottery',
                description = message,
                type = type,
                duration = duration
            })
        elseif Framework.Active == 'standalone' then
            -- Native FiveM notification
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        else
            -- Generic fallback
            print(message)
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- PLAYER DATA FUNCTIONS (SERVER-SIDE ONLY)
-- ════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then
    
    function Framework.GetPlayer(source)
        if Framework.Active == 'vorp_core' then
            local User = Framework.Core.getUser(source)
            return User and User.getUsedCharacter or nil
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Framework.Core.Functions.GetPlayer(source)
        elseif Framework.Active == 'redem_roleplay' then
            return Framework.Core.GetPlayer(source)
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Framework.Core.Functions.GetPlayer(source)
        end
        return nil
    end
    
    function Framework.GetPlayerMoney(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return 0 end
        
        if Framework.Active == 'vorp_core' then
            return Player.money or 0
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.PlayerData.money.cash or 0
        elseif Framework.Active == 'redem_roleplay' then
            return Player.getMoney() or 0
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.PlayerData.money.cash or 0
        end
        return 0
    end
    
    function Framework.RemoveMoney(source, amount)
        local Player = Framework.GetPlayer(source)
        if not Player then return false end
        
        if Framework.Active == 'vorp_core' then
            Player.removeCurrency(0, amount)
            return true
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.Functions.RemoveMoney('cash', amount)
        elseif Framework.Active == 'redem_roleplay' then
            Player.removeMoney(amount)
            return true
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.Functions.RemoveMoney('cash', amount)
        end
        return false
    end
    
    function Framework.AddMoney(source, amount)
        local Player = Framework.GetPlayer(source)
        if not Player then return false end
        
        if Framework.Active == 'vorp_core' then
            Player.addCurrency(0, amount)
            return true
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.Functions.AddMoney('cash', amount)
        elseif Framework.Active == 'redem_roleplay' then
            Player.addMoney(amount)
            return true
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.Functions.AddMoney('cash', amount)
        end
        return false
    end
    
    function Framework.GetPlayerIdentifier(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return nil end
        
        if Framework.Active == 'vorp_core' then
            return Player.charIdentifier
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.PlayerData.citizenid
        elseif Framework.Active == 'redem_roleplay' then
            return Player.getIdentifier()
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.PlayerData.citizenid
        end
        return nil
    end
    
    function Framework.GetPlayerName(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return 'Unknown' end
        
        if Framework.Active == 'vorp_core' then
            return Player.firstname .. ' ' .. Player.lastname
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        elseif Framework.Active == 'redem_roleplay' then
            return Player.getName()
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
        return 'Unknown'
    end
    
    function Framework.GetPlayerFirstName(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return 'Unknown' end
        
        if Framework.Active == 'vorp_core' then
            return Player.firstname
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.PlayerData.charinfo.firstname
        elseif Framework.Active == 'redem_roleplay' then
            local name = Player.getName()
            return name:match("^%S+") or 'Unknown'
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.PlayerData.charinfo.firstname
        end
        return 'Unknown'
    end
    
    function Framework.GetPlayerLastName(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return '' end
        
        if Framework.Active == 'vorp_core' then
            return Player.lastname
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            return Player.PlayerData.charinfo.lastname
        elseif Framework.Active == 'redem_roleplay' then
            local name = Player.getName()
            return name:match("%s(.+)$") or ''
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            return Player.PlayerData.charinfo.lastname
        end
        return ''
    end
    
    -- ════════════════════════════════════════════════════════════════════════════════
    -- CALLBACK SYSTEM
    -- ════════════════════════════════════════════════════════════════════════════════
    
    function Framework.RegisterCallback(name, cb)
        if Framework.Active == 'vorp_core' then
            Framework.Core.Callback.Register(name, cb)
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            Framework.Core.Functions.CreateCallback(name, cb)
        elseif Framework.Active == 'redem_roleplay' then
            Framework.Core.RegisterServerCallback(name, cb)
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            Framework.Core.Functions.CreateCallback(name, cb)
        else
            -- Standalone callback system
            RegisterNetEvent(name, function(...)
                local source = source
                cb(source, function(result)
                    TriggerClientEvent(name .. ':response', source, result)
                end, ...)
            end)
        end
    end
    
    -- ════════════════════════════════════════════════════════════════════════════════
    -- WEBHOOK SYSTEM
    -- ════════════════════════════════════════════════════════════════════════════════
    
    function Framework.SendWebhook(title, message, color)
        if not Config.Webhook.enabled or Config.Webhook.url == '' then
            return
        end
        
        if Framework.Active == 'vorp_core' then
            Framework.Core.AddWebhook(
                title,
                Config.Webhook.url,
                message,
                color or Config.Webhook.colorWinner,
                Config.Webhook.name,
                Config.Webhook.logo,
                Config.Webhook.footerLogo,
                Config.Webhook.avatar
            )
        else
            -- Generic Discord webhook
            local embed = {
                {
                    ['title'] = title,
                    ['description'] = message,
                    ['color'] = color or Config.Webhook.colorWinner,
                    ['footer'] = {
                        ['text'] = Config.ServerInfo.name .. ' | ' .. os.date('%Y-%m-%d %H:%M:%S'),
                        ['icon_url'] = Config.Webhook.footerLogo
                    },
                    ['author'] = {
                        ['name'] = Config.Webhook.name,
                        ['icon_url'] = Config.Webhook.logo
                    }
                }
            }
            
            PerformHttpRequest(Config.Webhook.url, function(err, text, headers) end, 'POST', json.encode({
                username = Config.Webhook.name,
                avatar_url = Config.Webhook.avatar,
                embeds = embed
            }), { ['Content-Type'] = 'application/json' })
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- CLIENT-SIDE CALLBACK SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

if not IsDuplicityVersion() then
    
    function Framework.TriggerCallback(name, cb, ...)
        if Framework.Active == 'vorp_core' then
            Framework.Core.Callback.TriggerAwait(name, cb, ...)
        elseif Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' then
            Framework.Core.Functions.TriggerCallback(name, cb, ...)
        elseif Framework.Active == 'redem_roleplay' then
            Framework.Core.TriggerServerCallback(name, cb, ...)
        elseif Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
            Framework.Core.Functions.TriggerCallback(name, cb, ...)
        else
            -- Standalone callback system
            local requestId = math.random(100000, 999999)
            RegisterNetEvent(name .. ':response', function(result)
                cb(result)
            end)
            TriggerServerEvent(name, ...)
        end
    end
    
end

-- Initialize framework on resource start
CreateThread(function()
    Framework.Init()
end)
