--[[
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                
    🐺 LXR Lottery System - FiveM Resource Manifest
    
    Multi-framework lottery system for RedM with automatic framework detection,
    comprehensive security features, and full compatibility with LXR-Core, RSG-Core,
    VORP, and other major frameworks.
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'
game 'rdr3'

-- ═══════════════════════════════════════════════════════════════════════════════
-- RESOURCE METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

name 'LXR Lottery System'
description 'Multi-framework lottery system for RedM with automatic detection, security features, and comprehensive customization'
author 'iBoss21 / The Lux Empire'
version '2.0.0'

-- ═══════════════════════════════════════════════════════════════════════════════
-- LUA VERSION
-- ═══════════════════════════════════════════════════════════════════════════════

lua54 'yes'

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED SCRIPTS (Loaded on both client and server)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: Configuration and framework adapter available to both sides

shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT SCRIPTS (Loaded on client only)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: UI, prompts, NPCs, blips, and client-side interactions

client_scripts {
    'client/client.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER SCRIPTS (Loaded on server only)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: Database, money management, winner selection, security validation

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES (Optional - Framework detection handles these at runtime)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Note: These are optional dependencies. The script will auto-detect which
-- framework is running and adapt accordingly. No hard dependencies required.

-- dependencies {
--     'oxmysql'  -- Only oxmysql is required for database operations
-- }
