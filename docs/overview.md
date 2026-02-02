# 🐺 LXR Lottery System - Overview

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

**The Land of Wolves 🐺 | Georgian RP 🇬🇪**

---

## What is LXR Lottery?

LXR Lottery is a comprehensive, multi-framework lottery system for RedM that allows players to purchase lottery tickets at various locations throughout the map. The system automatically draws winners at configured intervals, distributing jackpots that grow with each ticket purchase.

## Key Features

### 🎯 Core Functionality
- **Multiple Lottery Locations**: Configure lottery booths in major towns (Blackwater, Valentine, Rhodes, Saint Denis, etc.)
- **Dynamic Jackpot System**: Jackpot grows with each ticket purchased
- **Automated Winner Selection**: Random winner selection after configured time period
- **Persistent State**: All data saved to database, survives server restarts
- **Winner Claims**: Winners can claim their prizes at any lottery location

### 🔧 Multi-Framework Support
- **LXR-Core** (Primary)
- **RSG-Core** (Primary)
- **VORP Core** (Supported)
- **RedEM:RP** (Optional)
- **QBR-Core** (Optional)
- **QR-Core** (Optional)
- **Standalone** (Fallback)

Automatic framework detection means zero configuration required!

### 🛡️ Security Features
- Server-side validation for all transactions
- Distance validation to prevent exploits
- Money validation before purchases
- Cooldown system to prevent spam
- Rate limiting for ticket purchases
- Suspicious activity logging

### 🎨 Customization
- Configurable lottery locations with NPCs and blips
- Adjustable ticket prices and jackpot settings
- Ticket purchase limits (fair play)
- Multiple language support (English, German, Georgian)
- Discord webhook integration for announcements
- Customizable timers and cooldowns

### ⚡ Performance
- Optimized database queries with caching
- Minimal server overhead
- Client FPS impact optimization
- Efficient tick usage
- Resource cleanup on restart

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    LXR Lottery System                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   Config     │───▶│   Framework  │───▶│   Client     │  │
│  │   config.lua │    │   Adapter    │    │  client.lua  │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         │                    │                    │          │
│         │                    │                    │          │
│         ▼                    ▼                    ▼          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Server (server.lua)                      │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │  │
│  │  │  Database   │  │   Winner    │  │  Security   │  │  │
│  │  │  Management │  │  Selection  │  │ Validation  │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
│                            │                                │
│                            ▼                                │
│                    ┌──────────────┐                         │
│                    │   Database   │                         │
│                    │   (oxmysql)  │                         │
│                    └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

## How It Works

1. **Player Interaction**: Players approach lottery NPCs at configured locations
2. **Ticket Purchase**: Players buy tickets (configurable price, optional limit per player)
3. **Jackpot Growth**: Each ticket purchase adds to the jackpot
4. **Timer Countdown**: Automatic countdown timer (configurable duration)
5. **Winner Selection**: Random winner selected from all ticket holders
6. **Announcement**: Winner announced to server (optional) and logged to Discord
7. **Prize Claim**: Winner can claim prize at any lottery location
8. **Reset**: System resets for next lottery round

## Quick Start

1. **Installation**: See [installation.md](installation.md)
2. **Configuration**: See [configuration.md](configuration.md)
3. **Framework Setup**: See [frameworks.md](frameworks.md)

## Version Information

- **Current Version**: 2.0.0
- **Framework Support**: Multi-framework with auto-detection
- **Database**: oxmysql
- **Lua Version**: 5.4

## Credits

- **Script Conversion**: iBoss21 / The Lux Empire
- **Original Script**: RetryR1v2 (mms-lottery)
- **Server**: The Land of Wolves 🐺

## Links

- **Website**: https://www.wolves.land
- **Discord**: https://discord.gg/CrKcWdfd3A
- **GitHub**: https://github.com/iBoss21
- **Store**: https://theluxempire.tebex.io

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
