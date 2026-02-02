# 🐺 LXR Lottery System - Framework Support

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Multi-Framework Architecture

LXR Lottery uses a **unified framework adapter** that provides a single API for all framework-specific operations. This means the core lottery logic works identically across all supported frameworks.

### Supported Frameworks

| Framework | Status | Priority | Auto-Detect |
|-----------|--------|----------|-------------|
| **LXR-Core** | ✅ Primary | 1 | Yes |
| **RSG-Core** | ✅ Primary | 2 | Yes |
| **VORP Core** | ✅ Supported | 3 | Yes |
| **RedEM:RP** | ⚠️ Optional | 4 | Yes |
| **QBR-Core** | ⚠️ Optional | 5 | Yes |
| **QR-Core** | ⚠️ Optional | 6 | Yes |
| **Standalone** | ✅ Fallback | 7 | Always available |

---

## How Auto-Detection Works

### Detection Process

```
1. Check if Config.Framework = 'auto'
   ├─ Yes: Run detection
   └─ No: Use manual framework

2. Check frameworks in priority order:
   ├─ lxr-core (resource started?)
   ├─ rsg-core (resource started?)
   ├─ vorp_core (resource started?)
   ├─ redem_roleplay (resource started?)
   ├─ qbr-core (resource started?)
   ├─ qr-core (resource started?)
   └─ Fallback to standalone

3. Load framework core object
4. Initialize adapter functions
```

### Console Output

When the script starts, you'll see:

```
[LXR-Lottery] Framework detected: vorp_core
```

or

```
[LXR-Lottery] Framework detected: lxr-core
```

---

## Framework-Specific Details

### LXR-Core (Primary)

**Resource Name:** `lxr-core`

**Features:**
- Modern event structure
- ox_lib notifications
- ox_lib menus
- Optimized for LXR ecosystem

**Dependencies:**
- `lxr-core`
- `ox_lib`
- `lxr-inventory` (optional)

**Adapter Functions:**
```lua
Framework.Core = exports['lxr-core']:GetCoreObject()
```

---

### RSG-Core (Primary)

**Resource Name:** `rsg-core`

**Features:**
- RSGCore event naming
- ox_lib notifications
- ox_lib menus
- RedM-optimized

**Dependencies:**
- `rsg-core`
- `ox_lib`
- `rsg-inventory` (optional)

**Adapter Functions:**
```lua
Framework.Core = exports['rsg-core']:GetCoreObject()
```

---

### VORP Core (Supported)

**Resource Name:** `vorp_core`

**Features:**
- Legacy support maintained
- VORP notifications (native)
- Feather-menu support
- BCC-utils integration

**Dependencies:**
- `vorp_core`
- `bcc-utils`
- `feather-menu`
- `vorp_inventory` (optional)

**Adapter Functions:**
```lua
Framework.Core = exports.vorp_core:GetCore()
```

**Notes:**
- Uses different notification system (VORPcore.NotifyTip)
- Character data structure differs
- Fully backward compatible with mms-lottery

---

### RedEM:RP (Optional)

**Resource Name:** `redem_roleplay`

**Features:**
- RedEM event structure
- RedEM notifications
- RedEM inventory

**Dependencies:**
- `redem_roleplay`

**Adapter Functions:**
```lua
Framework.Core = exports['redem_roleplay']:GetCoreObject()
```

---

### QBR-Core / QR-Core (Optional)

**Resource Names:** `qbr-core` / `qr-core`

**Features:**
- QBCore-style events
- ox_lib notifications
- QBCore-style data structures

**Dependencies:**
- `qbr-core` or `qr-core`
- `ox_lib`

**Adapter Functions:**
```lua
Framework.Core = exports['qbr-core']:GetCoreObject()
Framework.Core = exports['qr-core']:GetCoreObject()
```

---

### Standalone Mode (Fallback)

**Features:**
- No framework required
- Basic chat notifications
- Limited functionality
- Good for testing

**What Works:**
- Lottery locations
- NPCs and blips
- Menu system (basic)
- Timer system
- Database operations

**What Doesn't Work:**
- Money transactions (requires framework)
- Player identification (uses basic Steam ID)
- Advanced notifications

---

## Framework Adapter API

The adapter (`shared/framework.lua`) provides these unified functions:

### Initialization

```lua
Framework.Init()
-- Returns: Active framework name
```

### Notifications

```lua
-- Server-side
Framework.Notify(source, message, duration, type)

-- Client-side
Framework.Notify(message, duration, type)
```

**Parameters:**
- `source` (server only): Player server ID
- `message`: Notification text
- `duration`: Time to show (milliseconds)
- `type`: 'inform', 'success', 'error', 'warning'

### Player Data (Server-Side)

```lua
-- Get player object
local Player = Framework.GetPlayer(source)

-- Get player money
local money = Framework.GetPlayerMoney(source)

-- Add money
Framework.AddMoney(source, amount)

-- Remove money
Framework.RemoveMoney(source, amount)

-- Get player identifier
local identifier = Framework.GetPlayerIdentifier(source)

-- Get player name
local fullname = Framework.GetPlayerName(source)
local firstname = Framework.GetPlayerFirstName(source)
local lastname = Framework.GetPlayerLastName(source)
```

### Callbacks

```lua
-- Server: Register callback
Framework.RegisterCallback('lottery:getMoney', function(source, cb)
    local money = Framework.GetPlayerMoney(source)
    cb(money)
end)

-- Client: Trigger callback
Framework.TriggerCallback('lottery:getMoney', function(money)
    print('Player has $' .. money)
end)
```

### Webhooks (Server-Side)

```lua
Framework.SendWebhook(title, message, color)
```

---

## Manual Framework Selection

If auto-detection doesn't work or you want to force a specific framework:

```lua
Config.Framework = 'vorp_core'  -- Force VORP
```

**Valid Options:**
- `'lxr-core'`
- `'rsg-core'`
- `'vorp_core'`
- `'redem_roleplay'`
- `'qbr-core'`
- `'qr-core'`
- `'standalone'`

---

## Adding a New Framework

To add support for a new framework:

### Step 1: Add Framework Settings

Edit `config.lua`:

```lua
Config.FrameworkSettings['your-framework'] = {
    resource = 'your-framework',
    notifications = 'your-notify-system',
    inventory = 'your-inventory',
    menu = 'your-menu',
    utils = 'your-utils',
    events = {
        server = 'your:server:%s',
        client = 'your:client:%s',
        callback = 'your:callback:%s'
    }
}
```

### Step 2: Update Framework Adapter

Edit `shared/framework.lua`:

```lua
-- In Framework.Init()
elseif Framework.Active == 'your-framework' then
    Framework.Core = exports['your-framework']:GetCoreObject()

-- Add to each adapter function
elseif Framework.Active == 'your-framework' then
    -- Your framework-specific code
```

### Step 3: Test Thoroughly

1. Set `Config.Framework = 'your-framework'`
2. Test all functions:
   - Notifications
   - Money operations
   - Player data
   - Callbacks
3. Verify in-game functionality

---

## Framework Compatibility Matrix

| Feature | LXR | RSG | VORP | RedEM | QBR | QR | Standalone |
|---------|-----|-----|------|-------|-----|----|----|
| Auto-detect | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Money System | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Player Data | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Callbacks | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Webhooks | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| NPCs/Blips | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Menus | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |

**Legend:**
- ✅ Full support
- ⚠️ Basic/limited support
- ❌ Not supported

---

## Troubleshooting

### Wrong Framework Detected

**Problem:** Script detects wrong framework or standalone

**Solutions:**
1. Check load order in `server.cfg` - framework must load first
2. Verify framework resource is actually started
3. Try manual selection: `Config.Framework = 'your-framework'`
4. Enable debug: `Config.Debug = true` and check console

### Notifications Not Showing

**Problem:** No notifications appear in-game

**Solutions:**
1. Check if notification resource is loaded (ox_lib, etc.)
2. Verify framework settings in `Config.FrameworkSettings`
3. Test with different notification types
4. Check F8 console for errors

### Money Not Being Removed/Added

**Problem:** Transactions don't work

**Solutions:**
1. Verify player has sufficient funds
2. Check if framework's money system is working
3. Test in standalone framework to isolate issue
4. Enable debug logging
5. Check database for transaction records

### Callback Errors

**Problem:** Callbacks timeout or fail

**Solutions:**
1. Verify both client and server are using same framework
2. Check callback name matches on both sides
3. Ensure callback is registered before being called
4. Test with framework's native callback system first

---

## Best Practices

### For Server Owners

1. **Use auto-detection** unless you have a reason not to
2. **Keep framework updated** for best compatibility
3. **Test after framework updates** to ensure continued compatibility
4. **Monitor console** for framework-related errors
5. **Don't mix frameworks** (one server = one framework)

### For Developers

1. **Use adapter functions** instead of direct framework calls
2. **Test on multiple frameworks** before release
3. **Handle nil returns gracefully** 
4. **Document framework-specific quirks**
5. **Maintain backward compatibility** when possible

---

## Next Steps

- ✅ Review event system: [events.md](events.md)
- ✅ Learn about security: [security.md](security.md)
- ✅ Optimize performance: [performance.md](performance.md)

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
