# 🐺 LXR Lottery System - Configuration Guide

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Configuration Overview

The `config.lua` file is the central configuration hub for the LXR Lottery System. It uses a highly organized structure with clear sections separated by visual banners.

---

## Server Information

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Lottery', 'Economy', 'Gambling'}
}
```

**Purpose:** Server branding and identification.  
**Customization:** Update with your server information.

---

## Framework Configuration

```lua
Config.Framework = 'auto'  -- 'auto' or manual selection
```

**Options:**
- `'auto'` - Automatically detect framework (recommended)
- `'lxr-core'` - Force LXR-Core
- `'rsg-core'` - Force RSG-Core
- `'vorp_core'` - Force VORP Core
- `'redem_roleplay'` - Force RedEM:RP
- `'qbr-core'` - Force QBR-Core
- `'qr-core'` - Force QR-Core
- `'standalone'` - Run without framework

**Recommendation:** Leave as `'auto'` unless you have specific requirements.

### Framework Settings

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        menu = 'ox_lib',
        utils = 'lxr-utils',
        events = { ... }
    },
    -- Additional framework configurations...
}
```

**Purpose:** Defines framework-specific resource names and event patterns.  
**Customization:** Usually no changes needed unless using custom framework builds.

---

## Language Configuration

```lua
Config.Lang = 'en'  -- 'en', 'de', 'ge'
```

**Supported Languages:**
- `'en'` - English
- `'de'` - German (Deutsch)
- `'ge'` - Georgian (ქართული)

### Adding Custom Languages

To add a new language:

```lua
Config.Locale.fr = {
    PromptName = 'Loterie',
    LotteryHeader = 'Système de Loterie',
    -- Add all translation keys...
}
```

Then set `Config.Lang = 'fr'`.

---

## General Settings

```lua
Config.General = {
    enableBlips = true,              -- Show map blips
    enableNPCs = true,               -- Spawn NPCs
    show3DText = true,               -- Show 3D text labels
    interactionDistance = 2.0,       -- Interaction distance (meters)
    npcModel = 'u_f_m_tumgeneralstoreowner_01'  -- NPC model hash
}
```

**Key Options:**
- `enableBlips`: If `false`, no map markers will appear
- `enableNPCs`: If `false`, no NPCs spawn (still functional via coordinates)
- `show3DText`: Show floating text above lottery locations
- `interactionDistance`: How close players need to be to interact
- `npcModel`: RedM ped model for lottery vendors

---

## Lottery Locations

```lua
Config.LotteryStations = {
    {
        name = 'Blackwater',
        coords = vector3(-808.3, -1292.35, 43.66),
        NpcHeading = 269.78,
        blipSprite = 'blip_shop_store',
        blipScale = 0.2
    },
    -- Add more locations...
}
```

### Location Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Location name (for reference) |
| `coords` | vector3 | XYZ coordinates |
| `NpcHeading` | float | Direction NPC faces (0-360) |
| `blipSprite` | string | Map blip icon |
| `blipScale` | float | Blip size on map |

### Finding Coordinates

Use these in-game to get coordinates:
```lua
/getcoords  -- If you have admin tools
-- Or use a coordinate script
```

### Adding New Locations

Simply copy a location block and modify:

```lua
{
    name = 'Armadillo',
    coords = vector3(-3685.0, -2623.0, -13.0),
    NpcHeading = 180.0,
    blipSprite = 'blip_shop_store',
    blipScale = 0.2
},
```

---

## Winner & Timing Settings

```lua
Config.Winner = {
    pickTimeMinutes = 60,        -- Draw interval (minutes)
    announceWinner = true,       -- Announce winner to all players
    announceIfNoWinner = true    -- Announce when no tickets sold
}
```

**Pick Time:**
- Measured in minutes
- Recommended: 30-120 minutes
- Shorter = more frequent draws
- Longer = larger jackpots

**Announcements:**
- `announceWinner`: Broadcasts winner name and prize
- `announceIfNoWinner`: Notifies when draw happens but no tickets sold

---

## Ticket Settings

```lua
Config.Tickets = {
    limitEnabled = true,    -- Enable per-player ticket limit
    maxPerPlayer = 3,       -- Maximum tickets per player per draw
    price = 5               -- Ticket price in dollars
}
```

### Ticket Limits

**Why limit tickets?**
- Ensures fair play
- Prevents rich players from dominating
- Balances economy

**Disable limits:**
```lua
Config.Tickets.limitEnabled = false
```

**Pricing Recommendations:**
- Low economy servers: $1-5
- Medium economy: $5-20
- High economy: $20-100

---

## Jackpot Settings

```lua
Config.Jackpot = {
    useStartAmount = false,      -- Start with base jackpot
    startAmount = 10,            -- Starting jackpot amount
    ticketContribution = 5       -- Amount added per ticket
}
```

### How Jackpot Works

**Without start amount:**
- Jackpot starts at $0
- Grows with each ticket purchase
- First draw jackpot = (tickets sold × price)

**With start amount:**
- Jackpot starts at `startAmount`
- Grows with each ticket: jackpot += `ticketContribution`
- First draw minimum = `startAmount`

**Example:**
```lua
Config.Jackpot.useStartAmount = true
Config.Jackpot.startAmount = 50
Config.Tickets.price = 10

-- If 10 tickets sold:
-- Jackpot = $50 + (10 × $10) = $150
```

---

## Webhook Configuration

```lua
Config.Webhook = {
    enabled = true,
    url = '',  -- Your Discord webhook URL
    
    titleWinner = '🎰 Lottery Winner!',
    colorWinner = 3066993,  -- Green
    
    titleNoWinner = '🎰 Lottery Draw - No Winner',
    colorNoWinner = 15158332,  -- Red
    
    name = 'LXR Lottery System',
    logo = '',
    footerLogo = '',
    avatar = ''
}
```

### Setting Up Discord Webhooks

1. Go to your Discord server settings
2. Navigate to Integrations → Webhooks
3. Create a new webhook
4. Copy the webhook URL
5. Paste into `Config.Webhook.url`

### Webhook Colors

Discord uses decimal color codes:
- Green (success): `3066993`
- Red (failure/no winner): `15158332`
- Blue: `3447003`
- Yellow: `16776960`
- Purple: `10181046`

Convert hex to decimal: https://www.rapidtables.com/convert/number/hex-to-decimal.html

---

## Database Tables

```lua
Config.DatabaseTables = {
    tickets = 'mms_lotteryticket',
    jackpot = 'mms_lotteryjackpot',
    winners = 'mms_lotterywinner',
    timer = 'mms_lotterytimer'
}
```

**Purpose:** Customize database table names if needed.  
**Default:** Uses mms_ prefix for backward compatibility.

**Custom Example:**
```lua
Config.DatabaseTables = {
    tickets = 'lxr_lottery_tickets',
    jackpot = 'lxr_lottery_jackpot',
    winners = 'lxr_lottery_winners',
    timer = 'lxr_lottery_timer'
}
```

⚠️ **Important:** If you change these, you must also rename the tables in your database or update the SQL installation script.

---

## Security & Anti-Abuse

```lua
Config.Security = {
    enabled = true,
    validateDistance = true,
    maxDistance = 5.0,
    validateMoney = true,
    cooldownBetweenPurchases = 1000,
    logSuspiciousActivity = true,
    maxPurchasesPerMinute = 10,
    preventDuplicatePurchases = true
}
```

### Security Options Explained

| Option | Description | Recommended |
|--------|-------------|-------------|
| `enabled` | Master security toggle | `true` |
| `validateDistance` | Check player proximity | `true` |
| `maxDistance` | Max allowed distance (meters) | `5.0` |
| `validateMoney` | Verify sufficient funds | `true` |
| `cooldownBetweenPurchases` | Delay between tickets (ms) | `1000` |
| `logSuspiciousActivity` | Log potential exploits | `true` |
| `maxPurchasesPerMinute` | Rate limit | `10` |
| `preventDuplicatePurchases` | Prevent rapid duplicates | `true` |

**For production servers, keep all security features enabled!**

---

## Performance Optimization

```lua
Config.Performance = {
    updateInterval = 2000,          -- Update frequency (ms)
    cleanupOldWinners = true,       -- Auto-cleanup old records
    cleanupAfterDays = 30,          -- Days to keep records
    cacheTimeout = 300000,          -- Cache duration (5 min)
    usePromptGroups = true          -- Optimized prompts
}
```

### Performance Tips

**Update Interval:**
- Higher = less server load
- Lower = more responsive UI
- Recommended: 2000-5000ms

**Cleanup:**
- Enable to prevent database bloat
- `cleanupAfterDays`: Balance between history and performance
- Old winner records automatically purged

**Caching:**
- Reduces database queries
- `cacheTimeout`: How long to cache data
- 300000ms = 5 minutes

---

## Debug Mode

```lua
Config.Debug = false
```

**Enable for troubleshooting:**
```lua
Config.Debug = true
```

**Debug features:**
- Detailed console logs
- Framework detection info
- Event trigger logging
- Database query logging
- Error stack traces

**⚠️ Disable in production for performance!**

---

## Backward Compatibility

The config includes backward compatibility aliases:

```lua
-- Old config values still work
Config.LotteryBlips = Config.General.enableBlips
Config.TicketPrice = Config.Tickets.price
-- etc...
```

This means old configurations from mms-lottery will continue to work.

---

## Configuration Best Practices

1. **Start with defaults** - Test before making changes
2. **Backup before editing** - Keep a copy of working config
3. **Change one thing at a time** - Easier to troubleshoot
4. **Test after changes** - Verify functionality
5. **Document custom changes** - Add comments explaining why
6. **Review security settings** - Never disable without reason
7. **Match economy** - Adjust prices to your server's economy
8. **Consider player count** - More players = can have more locations

---

## Next Steps

- ✅ Review framework adapter: [frameworks.md](frameworks.md)
- ✅ Learn about security: [security.md](security.md)
- ✅ Optimize performance: [performance.md](performance.md)
- ✅ Explore event system: [events.md](events.md)

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
