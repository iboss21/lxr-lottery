--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                
    🐺 LXR Lottery System - Configuration
    
    This configuration file controls the lottery system for RedM. Players can buy
    lottery tickets at various locations around the map. A winner is randomly selected
    after a configured time period, and the jackpot grows with each ticket purchase.
    Supports multiple frameworks with automatic detection and provides comprehensive
    customization options for locations, pricing, timing, and translations.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 2.0.0
    Performance Target: Optimized for minimal server overhead with secure server-side validation
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Lottery, Economy, Gambling
    
    Framework Support:
    - LXR-Core (Primary)
    - RSG-Core (Primary)
    - VORP Core (Supported)
    - RedEM:RP (Optional - if detected)
    - QBR Core (Optional - if detected)
    - QR Core (Optional - if detected)
    - Standalone (Fallback)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Conversion: iBoss21 / The Lux Empire for The Land of Wolves
    Original Script: RetryR1v2 (mms-lottery)
    Multi-Framework Support: iBoss21 / The Lux Empire
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-lottery"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Lottery', 'Economy', 'Gambling'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        menu = 'ox_lib',
        utils = 'lxr-utils',
        -- Event naming convention
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        inventory = 'rsg-inventory',
        menu = 'ox_lib',
        utils = 'rsg-utils',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        inventory = 'vorp_inventory',
        menu = 'feather-menu',
        utils = 'bcc-utils',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource = 'redem_roleplay',
        notifications = 'redem',
        inventory = 'redem_inventory',
        menu = 'redem_menu',
        utils = 'redem_utils',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        notifications = 'ox_lib',
        inventory = 'qbr-inventory',
        menu = 'ox_lib',
        utils = 'qbr-utils',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource = 'qr-core',
        notifications = 'ox_lib',
        inventory = 'qr-inventory',
        menu = 'ox_lib',
        utils = 'qr-utils',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        -- Minimal functionality without framework
        notifications = 'print',
        inventory = 'none',
        menu = 'none',
        utils = 'none'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- Language for notifications (en, de, ge, etc.)

Config.Locale = {
    en = {
        -- Prompts & Labels
        PromptName = 'Lottery',
        LotteryHeader = 'Lottery System',
        TextLabel3D = 'Lottery',
        
        -- Menu Options
        LabelBuyTicket = 'Buy Ticket - Price: $',
        LabelGetWinnings = 'Claim Winnings!',
        CloseLotterieMenu = 'Close Lottery',
        
        -- Status Messages
        NextWinnerPick = 'Next Draw: ',
        MinuteLabel = ' minutes',
        JackpotAmount = 'Current Jackpot: $',
        
        -- Success Messages
        TicketBought = 'Lottery ticket purchased for $',
        WinningsGetLabel = 'Congratulations! You won $',
        
        -- Error Messages
        NotEnoghMoney = 'Not enough money',
        MaxTicketsBought = 'You already have the maximum tickets! Max: ',
        SadNoWin = 'No winnings available.',
        
        -- Announcements
        NoTicketsBought = 'Lottery: No tickets were purchased, so there is no winner!',
        TheWinnerIs = 'The winner is: ',
        HeWins = ' Prize: $',
        LotteryOver = 'A winner has been drawn! Check the lottery to see if you won.'
    },
    de = {
        -- German translations (Original)
        PromptName = 'Lotterie',
        LotteryHeader = 'Lotterie',
        TextLabel3D = 'Lotterie',
        LabelBuyTicket = 'Kaufe Los Preis: $',
        LabelGetWinnings = 'Gewinn Auszahlen!',
        CloseLotterieMenu = 'Lotterie Schließen',
        NextWinnerPick = 'Nächste Ziehung in: ',
        MinuteLabel = ' Minuten',
        JackpotAmount = 'Aktueller Jackpot: $',
        TicketBought = 'Los für $',
        WinningsGetLabel = 'Herzlichen Glückwunsch du Gewinnst $',
        NotEnoghMoney = 'Nicht Genug Geld',
        MaxTicketsBought = 'Du hast schon genug Lose! Max Lose: ',
        SadNoWin = 'Leider keinen Gewinn.',
        NoTicketsBought = 'Lotterie: Es wurden keine Lose Gekauft somit gibt es keinen Gewinner schade!',
        TheWinnerIs = 'Der Gewinner ist: ',
        HeWins = ' Der Gewinn ist: $',
        LotteryOver = 'Es wurde ein Gewinner ausgelost schau in der Lotterie ob du Gewonnen hast'
    },
    ge = {
        -- Georgian translations
        PromptName = 'ლოტო',
        LotteryHeader = 'ლოტოს სისტემა',
        TextLabel3D = 'ლოტო',
        LabelBuyTicket = 'ბილეთის ყიდვა - ფასი: $',
        LabelGetWinnings = 'მოგების აღება!',
        CloseLotterieMenu = 'დახურვა',
        NextWinnerPick = 'შემდეგი გათამაშება: ',
        MinuteLabel = ' წუთი',
        JackpotAmount = 'ჯეკპოტი: $',
        TicketBought = 'ბილეთი შეძენილია $',
        WinningsGetLabel = 'გილოცავთ! თქვენ მოიგეთ $',
        NotEnoghMoney = 'არასაკმარისი თანხა',
        MaxTicketsBought = 'თქვენ უკვე გაქვთ მაქსიმალური ბილეთები! მაქს: ',
        SadNoWin = 'მოგება არ არის.',
        NoTicketsBought = 'ლოტო: ბილეთები არ იყო შეძენილი, გამარჯვებული არ არის!',
        TheWinnerIs = 'გამარჯვებულია: ',
        HeWins = ' პრიზი: $',
        LotteryOver = 'გამარჯვებული გამოვლინდა! შეამოწმეთ ლოტო.'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    enableBlips = true,              -- Show lottery locations on the map
    enableNPCs = true,               -- Spawn NPCs at lottery locations
    show3DText = true,               -- Show 3D text above lottery locations
    interactionDistance = 2.0,       -- Distance to interact with lottery NPCs
    npcModel = 'u_f_m_tumgeneralstoreowner_01' -- Default NPC model
}

-- Backward compatibility
Config.LotteryBlips = Config.General.enableBlips
Config.CreateNPC = Config.General.enableNPCs
Config.Show3dText = Config.General.show3DText

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LOTTERY LOCATIONS █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.LotteryStations = {
    {
        name = 'Blackwater',
        coords = vector3(-808.3, -1292.35, 43.66),
        NpcHeading = 269.78,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    },
    {
        name = 'Valentine',
        coords = vector3(-291.42, 784.18, 119.29),
        NpcHeading = 26.07,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    },
    {
        name = 'Rhodes',
        coords = vector3(1311.66, -1312.31, 76.79),
        NpcHeading = 327.44,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    },
    {
        name = 'Saint Denis',
        coords = vector3(2531.12, -1202.2, 53.68),
        NpcHeading = 272.05,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    },
    {
        name = 'Limpany',
        coords = vector3(-361.49, -140.6, 47.68),
        NpcHeading = 327.02,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WINNER & TIMING SETTINGS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Winner = {
    pickTimeMinutes = 60,            -- Time in minutes between winner selections
    announceWinner = true,           -- Announce the winner to all players
    announceIfNoWinner = true        -- Announce when there is no winner
}

-- Backward compatibility
Config.WinnerPickTime = Config.Winner.pickTimeMinutes
Config.AnnonceWinner = Config.Winner.announceWinner
Config.AnnonceIfNoWinner = Config.Winner.announceIfNoWinner

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TICKET SETTINGS ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Tickets = {
    limitEnabled = true,             -- Limit tickets per player
    maxPerPlayer = 3,                -- Maximum tickets a player can buy
    price = 5                        -- Price per ticket in dollars
}

-- Backward compatibility
Config.LimitTickets = Config.Tickets.limitEnabled
Config.MaxTickets = Config.Tickets.maxPerPlayer
Config.TicketPrice = Config.Tickets.price

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ JACKPOT SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Jackpot = {
    useStartAmount = false,          -- Start jackpot with a base amount
    startAmount = 10,                -- Initial jackpot amount if enabled
    ticketContribution = 5           -- Amount added to jackpot per ticket (usually same as ticket price)
}

-- Backward compatibility
Config.UseStartAmount = Config.Jackpot.useStartAmount
Config.StartAmount = Config.Jackpot.startAmount

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WEBHOOK CONFIGURATION █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Webhook = {
    enabled = true,
    url = '',  -- Discord Webhook URL (leave empty to disable)
    
    -- Winner Webhook
    titleWinner = '🎰 Lottery Winner!',
    colorWinner = 3066993,  -- Green
    
    -- No Winner Webhook
    titleNoWinner = '🎰 Lottery Draw - No Winner',
    colorNoWinner = 15158332,  -- Red
    
    -- Webhook Branding
    name = 'LXR Lottery System',
    logo = '', -- 30x30px logo URL
    footerLogo = '', -- 30x30px footer logo URL
    avatar = '' -- Avatar URL for webhook
}

-- Backward compatibility
Config.EnableWebHook = Config.Webhook.enabled
Config.WHTitle = Config.Webhook.titleWinner
Config.WHTitleNoWinner = Config.Webhook.titleNoWinner
Config.WHLink = Config.Webhook.url
Config.WHColor = Config.Webhook.colorWinner
Config.WHName = Config.Webhook.name
Config.WHLogo = Config.Webhook.logo
Config.WHFooterLogo = Config.Webhook.footerLogo
Config.WHAvatar = Config.Webhook.avatar

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DATABASE TABLES ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.DatabaseTables = {
    tickets = 'mms_lotteryticket',
    jackpot = 'mms_lotteryjackpot',
    winners = 'mms_lotterywinner',
    timer = 'mms_lotterytimer'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-ABUSE █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    enabled = true,                      -- Enable security checks
    validateDistance = true,             -- Validate player distance from lottery location
    maxDistance = 5.0,                   -- Maximum allowed distance (server-side)
    validateMoney = true,                -- Validate player has sufficient money
    cooldownBetweenPurchases = 1000,    -- Minimum time between purchases (ms)
    logSuspiciousActivity = true,        -- Log potential exploits
    maxPurchasesPerMinute = 10,         -- Maximum ticket purchases per minute
    preventDuplicatePurchases = true    -- Prevent rapid duplicate purchases
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    updateInterval = 2000,               -- Jackpot/timer update interval (ms)
    cleanupOldWinners = true,            -- Clean up old winner records
    cleanupAfterDays = 30,               -- Days to keep winner records
    cacheTimeout = 300000,               -- Cache timeout for database queries (5 minutes)
    usePromptGroups = true              -- Use optimized prompt groups
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable debug prints and extra logging

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Startup banner
CreateThread(function()
    Wait(1000)
    local locale = Config.Locale[Config.Lang]
    print([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
            ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
            ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
            ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
            ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
            ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LOTTERY SYSTEM - SUCCESSFULLY LOADED
        ═══════════════════════════════════════════════════════════════════════════════
        
        Version:     2.0.0
        Server:      ]] .. Config.ServerInfo.name .. [[
        
        Framework:   ]] .. (Config.Framework == 'auto' and 'Auto-detect enabled' or Config.Framework) .. [[
        Language:    ]] .. Config.Lang .. [[
        Locations:   ]] .. #Config.LotteryStations .. [[
        
        Ticket Price: $]] .. Config.Tickets.price .. [[
        
        Max Tickets:  ]] .. (Config.Tickets.limitEnabled and tostring(Config.Tickets.maxPerPlayer) or 'Unlimited') .. [[
        Draw Timer:   ]] .. Config.Winner.pickTimeMinutes .. [[ minutes
        Security:     ]] .. (Config.Security.enabled and 'ENABLED ✓' or 'DISABLED ✗') .. [[
        Webhooks:     ]] .. (Config.Webhook.enabled and (Config.Webhook.url ~= '' and 'ENABLED ✓' or 'DISABLED (No URL)') or 'DISABLED ✗') .. [[
        Debug:        ]] .. (Config.Debug and 'ENABLED' or 'DISABLED') .. [[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
        Developer:   iBoss21 / The Lux Empire
        Website:     https://www.wolves.land
        Discord:     https://discord.gg/CrKcWdfd3A
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]])
end)