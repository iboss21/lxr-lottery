# 🐺 LXR Lottery System

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

**🐺 The Land of Wolves | Georgian RP 🇬🇪**  
**მგლების მიწა - რჩეულთა ადგილი! (The Land of Chosen Wolves!)**

---

## 📋 Overview

**LXR Lottery** is a comprehensive, multi-framework lottery system for RedM that allows players to purchase lottery tickets at various locations throughout the map. The system automatically draws winners at configured intervals, distributing jackpots that grow with each ticket purchase.

Built with enterprise-grade security, performance optimization, and full multi-framework compatibility - designed for **The Land of Wolves** and the broader RedM community.

---

## ✨ Key Features

### 🎯 Core Functionality
- ✅ **Multiple Lottery Locations** - Configure lottery booths in major towns
- ✅ **Dynamic Jackpot System** - Grows with each ticket purchased
- ✅ **Automated Winner Selection** - Random winner after configured timer
- ✅ **Persistent State** - Survives server restarts (database-backed)
- ✅ **Winner Claims** - Winners claim prizes at any lottery location
- ✅ **Fair Play** - Optional ticket limits per player

### 🔧 Multi-Framework Support
- **LXR-Core** (Primary) 🌟
- **RSG-Core** (Primary) 🌟
- **VORP Core** (Supported) ✓
- **RedEM:RP** (Optional) ⚡
- **QBR-Core** (Optional) ⚡
- **QR-Core** (Optional) ⚡
- **Standalone** (Fallback) 📦

**Automatic framework detection** means zero configuration required!

### 🛡️ Security Features
- ✅ Server-side validation for all transactions
- ✅ Distance validation (anti-exploit)
- ✅ Money validation before purchases
- ✅ Cooldown system (prevent spam)
- ✅ Rate limiting for ticket purchases
- ✅ Suspicious activity logging
- ✅ Resource name protection

### 🎨 Customization
- ✅ Configurable lottery locations with NPCs and blips
- ✅ Adjustable ticket prices and jackpot settings
- ✅ Ticket purchase limits (fair play)
- ✅ Multiple language support (English, German, Georgian)
- ✅ Discord webhook integration
- ✅ Customizable timers and cooldowns

### ⚡ Performance
- ✅ Optimized database queries with caching
- ✅ Minimal server overhead (< 0.1ms average)
- ✅ Client FPS impact optimization
- ✅ Efficient tick usage
- ✅ Automatic resource cleanup

---

## 📦 Installation

### Quick Start

1. **Download** and extract to your resources folder
2. **Rename** folder to exactly `lxr-lottery` (required!)
3. **Run** the SQL setup script (see [installation.md](docs/installation.md))
4. **Configure** settings in `config.lua`
5. **Add** to `server.cfg`:
   ```cfg
   ensure oxmysql
   ensure [your-framework]  # lxr-core, rsg-core, vorp_core, etc.
   ensure lxr-lottery
   ```
6. **Start** your server and verify the startup banner appears

### Detailed Instructions

See [📖 Installation Guide](docs/installation.md) for complete step-by-step instructions.

---

## 🎮 How It Works

1. **Players approach** lottery NPCs at configured locations (Blackwater, Valentine, etc.)
2. **Purchase tickets** at configured price (default $5)
3. **Jackpot grows** with each ticket purchased
4. **Timer counts down** to winner selection (default 60 minutes)
5. **Winner selected** randomly from all ticket holders
6. **Announcement** sent to server and Discord (optional)
7. **Winner claims prize** at any lottery location
8. **System resets** for next lottery round

---

## 📚 Documentation

Comprehensive documentation available in `/docs`:

- [📖 Overview](docs/overview.md) - System architecture and features
- [⚙️ Installation](docs/installation.md) - Step-by-step setup guide
- [🔧 Configuration](docs/configuration.md) - Detailed config options
- [🔌 Frameworks](docs/frameworks.md) - Multi-framework support details
- [📡 Events & API](docs/events.md) - Event system and API reference
- [🛡️ Security](docs/security.md) - Security features and best practices
- [⚡ Performance](docs/performance.md) - Optimization guide
- [📸 Screenshots](docs/screenshots.md) - Visual documentation requirements

---

## 🔧 Configuration Highlights

```lua
-- Framework (auto-detect or manual)
Config.Framework = 'auto'

-- Language
Config.Lang = 'en'  -- 'en', 'de', 'ge'

-- Ticket Settings
Config.Tickets = {
    limitEnabled = true,     -- Limit tickets per player
    maxPerPlayer = 3,        -- Max tickets per draw
    price = 5                -- Ticket price in dollars
}

-- Winner Settings
Config.Winner = {
    pickTimeMinutes = 60,    -- Draw interval
    announceWinner = true,   -- Announce to server
    announceIfNoWinner = true
}

-- Jackpot
Config.Jackpot = {
    useStartAmount = false,  -- Start with base amount
    startAmount = 10,
    ticketContribution = 5
}

-- Security
Config.Security = {
    enabled = true,          -- Master toggle
    validateDistance = true, -- Distance checks
    maxDistance = 5.0,       -- Max distance (meters)
    validateMoney = true,    -- Money validation
    logSuspiciousActivity = true
}
```

See [🔧 Configuration Guide](docs/configuration.md) for all options.

---

## 🏆 Credits

### Original Script
- **Author**: RetryR1v2 (mms-lottery)
- **GitHub**: https://github.com/RetryR1v2

### LXR Conversion & Multi-Framework Support
- **Converted By**: iBoss21 / The Lux Empire
- **For**: The Land of Wolves 🐺
- **GitHub**: https://github.com/iBoss21
- **Discord**: https://discord.gg/CrKcWdfd3A
- **Website**: https://www.wolves.land
- **Store**: https://theluxempire.tebex.io

---

## 🌐 Server Information

**Server Name**: The Land of Wolves 🐺  
**Tagline**: Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
**Description**: ისტორია ცოცხლდება აქ! (History Lives Here!)  
**Type**: Serious Hardcore Roleplay  
**Access**: Discord & Whitelisted  

**Links**:
- Website: https://www.wolves.land
- Discord: https://discord.gg/CrKcWdfd3A
- Server Listing: https://servers.redm.net/servers/detail/8gj7eb
- Store: https://theluxempire.tebex.io

---

## 🐛 Support

Need help? Have questions?

1. **Check Documentation**: See `/docs` folder
2. **Discord Support**: https://discord.gg/CrKcWdfd3A
3. **GitHub Issues**: Report bugs or request features
4. **Community Forum**: Ask questions, share configs

---

## 📝 Changelog

### Version 2.0.0 (Current)
- ✨ Complete rebrand for Land of Wolves / LXR style
- ✨ Multi-framework support with auto-detection
- ✨ Framework adapter layer for unified API
- ✨ Enhanced security features
- ✨ Performance optimizations
- ✨ Comprehensive documentation
- ✨ Multiple language support (EN, DE, GE)
- ✨ Resource name protection
- ✨ Backward compatibility with mms-lottery config

### Version 1.1.5 (Legacy)
- 🐛 Bug fixes
- Previous versions by RetryR1v2

See [installation.md](docs/installation.md) for migration guide from mms-lottery.

---

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

Based on mms-lottery by RetryR1v2

---

## 🎯 Requirements

### Required
- ✅ RedM Server (prerelease build)
- ✅ oxmysql
- ✅ One of the supported frameworks (or standalone mode)

### Optional (Framework-Specific)
- **VORP**: bcc-utils, feather-menu
- **LXR/RSG**: ox_lib
- **Others**: Check framework documentation

---

## 🚀 Performance Targets

- **Server**: < 0.1ms average (resmon)
- **Client**: < 0.05ms average (resmon)
- **Memory**: < 5MB
- **Database**: < 50ms query time

---

## 🔐 Security Notice

⚠️ **Keep all security features enabled in production!**

Never disable:
- `Config.Security.enabled`
- `Config.Security.validateDistance`
- `Config.Security.validateMoney`
- `Config.Security.logSuspiciousActivity`

See [🛡️ Security Guide](docs/security.md) for details.

---

## 🌟 Show Your Support

If you enjoy this script:
- ⭐ Star the repository on GitHub
- 🐺 Join The Land of Wolves Discord
- 💬 Share with your RedM community
- 🛒 Check out our other scripts at theluxempire.tebex.io

---

**🐺 Built with pride for The Land of Wolves and the RedM community 🐺**

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved 