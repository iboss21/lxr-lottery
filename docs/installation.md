# 🐺 LXR Lottery System - Installation Guide

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Prerequisites

Before installing LXR Lottery, ensure you have:

### Required
- ✅ **RedM Server** (prerelease build)
- ✅ **oxmysql** resource installed and configured
- ✅ **One of the supported frameworks**:
  - LXR-Core (recommended)
  - RSG-Core (recommended)
  - VORP Core
  - RedEM:RP
  - QBR-Core
  - QR-Core
  - Or run in standalone mode

### Optional (Framework-Specific)
- **For VORP**: bcc-utils, feather-menu
- **For LXR/RSG**: ox_lib
- **For others**: Check your framework's menu/notification dependencies

---

## Installation Steps

### Step 1: Download & Extract

1. Download the latest release from GitHub or your source
2. Extract the `lxr-lottery` folder
3. Place it in your server's `resources` directory

```
📁 server-resources/
  └── 📁 [lottery]/
      └── 📁 lxr-lottery/
          ├── 📁 client/
          ├── 📁 server/
          ├── 📁 shared/
          ├── 📁 docs/
          ├── 📄 config.lua
          ├── 📄 fxmanifest.lua
          └── 📄 README.md
```

**⚠️ CRITICAL: The folder MUST be named `lxr-lottery` exactly!**

The resource includes a runtime name protection check. If renamed, it will not start.

---

### Step 2: Database Setup

Execute the following SQL to create the required database tables:

```sql
-- Lottery Tickets Table
CREATE TABLE IF NOT EXISTS `mms_lotteryticket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `tickets` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lottery Jackpot Table
CREATE TABLE IF NOT EXISTS `mms_lotteryjackpot` (
  `jackpot` varchar(50) NOT NULL,
  `money` int(11) DEFAULT 0,
  PRIMARY KEY (`jackpot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lottery Winners Table
CREATE TABLE IF NOT EXISTS `mms_lotterywinner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `pricemoney` int(11) DEFAULT 0,
  `claimed` tinyint(1) DEFAULT 0,
  `won_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lottery Timer Table
CREATE TABLE IF NOT EXISTS `mms_lotterytimer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timer` int(11) DEFAULT 3600,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Important Notes:**
- The timer value is stored in seconds (default 3600 = 60 minutes)
- The system will auto-create the timer entry on first start
- Old ticket/jackpot data is cleared after each winner selection

---

### Step 3: Configuration

1. Open `config.lua`
2. Review and customize the settings:

**Essential Settings:**
```lua
-- Framework (usually leave as 'auto')
Config.Framework = 'auto'

-- Language
Config.Lang = 'en'  -- 'en', 'de', or 'ge'

-- Ticket Settings
Config.Tickets.price = 5
Config.Tickets.maxPerPlayer = 3
Config.Tickets.limitEnabled = true

-- Winner Draw Time
Config.Winner.pickTimeMinutes = 60

-- Jackpot
Config.Jackpot.useStartAmount = false
Config.Jackpot.startAmount = 10
```

**Locations:**
```lua
-- Edit or add lottery station locations
Config.LotteryStations = {
    {
        name = 'Blackwater',
        coords = vector3(-808.3, -1292.35, 43.66),
        NpcHeading = 269.78,
        -- ...
    },
    -- Add more...
}
```

For detailed configuration options, see [configuration.md](configuration.md).

---

### Step 4: Discord Webhooks (Optional)

To enable Discord notifications:

1. Create a webhook in your Discord server
2. Open `config.lua`
3. Update the webhook settings:

```lua
Config.Webhook = {
    enabled = true,
    url = 'YOUR_DISCORD_WEBHOOK_URL_HERE',
    -- ...
}
```

---

### Step 5: Server Configuration

Add the resource to your `server.cfg`:

```cfg
# LXR Lottery System
ensure oxmysql
ensure [your-framework]  # lxr-core, rsg-core, vorp_core, etc.
ensure lxr-lottery
```

**Load Order:**
1. oxmysql
2. Your framework (lxr-core, rsg-core, vorp_core, etc.)
3. lxr-lottery

---

### Step 6: Start the Server

1. Save all configuration files
2. Start or restart your RedM server
3. Check the console for the startup banner:

```
═══════════════════════════════════════════════════════════════════════════════

    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
    ...
    
═══════════════════════════════════════════════════════════════════════════════
🐺 LOTTERY SYSTEM - SUCCESSFULLY LOADED
═══════════════════════════════════════════════════════════════════════════════

Version:     2.0.0
Server:      The Land of Wolves 🐺

Framework:   Auto-detect enabled
...
```

If you see this banner, installation was successful!

---

## Verification

### Test Checklist

1. **Framework Detection**
   - Check console for "Framework detected: [framework-name]"
   - Verify correct framework is detected

2. **Database Tables**
   - All 4 tables should exist in your database
   - Timer table should have an initial entry

3. **In-Game Testing**
   - Visit a lottery location (Blackwater, Valentine, etc.)
   - NPCs should spawn at configured locations
   - Blips should appear on the map
   - Interaction prompt should appear near NPCs
   - Open the lottery menu
   - Verify current jackpot and timer display
   - Purchase a test ticket
   - Check database for ticket entry

4. **Winner Selection**
   - Wait for timer to expire (or manually trigger for testing)
   - Check console/Discord for winner announcement
   - Winner should be able to claim prize

---

## Troubleshooting

### Resource Name Mismatch Error

**Error:**
```
❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
Expected: lxr-lottery
Got: [some-other-name]
```

**Solution:** Rename the resource folder to exactly `lxr-lottery`.

---

### Framework Not Detected

**Error:** "Framework detected: standalone" when you have a framework installed

**Solution:**
1. Verify your framework is started before lxr-lottery
2. Check the framework resource name in `Config.FrameworkSettings`
3. Try manually setting `Config.Framework = 'vorp_core'` (or your framework)

---

### Database Connection Errors

**Error:** MySQL errors or "table doesn't exist"

**Solution:**
1. Verify oxmysql is installed and running
2. Check your MySQL connection in oxmysql config
3. Execute the SQL setup script again
4. Restart the server

---

### NPCs/Blips Not Spawning

**Solution:**
1. Check `Config.General.enableNPCs` and `Config.General.enableBlips` are `true`
2. Verify coordinates in `Config.LotteryStations`
3. Check client console (F8) for any errors
4. Try teleporting to a lottery location to test

---

## Updating from mms-lottery

If you're upgrading from the original mms-lottery:

1. **Backup your database** before proceeding
2. Your existing database tables will work (backward compatible)
3. Old configuration values are supported via backward compatibility layer
4. You can migrate your config gradually or start fresh
5. Test thoroughly before deploying to production

---

## Next Steps

- ✅ Configure lottery locations: [configuration.md](configuration.md)
- ✅ Learn about framework adapter: [frameworks.md](frameworks.md)
- ✅ Review security features: [security.md](security.md)
- ✅ Optimize performance: [performance.md](performance.md)

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
