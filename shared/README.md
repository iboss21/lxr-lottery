# 🐺 Shared Scripts

```
██╗     ██╗  ██╗██████╗     
██║     ╚██╗██╔╝██╔══██╗    
██║      ╚███╔╝ ██████╔╝    
██║      ██╔██╗ ██╔══██╗    
███████╗██╔╝ ██╗██║  ██║    
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    
```

**The Land of Wolves 🐺 | Georgian RP 🇬🇪**

---

## Purpose

This directory contains scripts loaded on **both client and server** sides, providing:

- **Framework Adapter**: Unified API for multi-framework support
- **Configuration**: Shared configuration accessible to both sides
- **Common Functions**: Utilities used by both client and server
- **Compatibility Layer**: Abstraction over framework differences

---

## Files

### framework.lua

**Multi-Framework Bridge Adapter**

Provides a unified interface for:

#### Framework Detection
- Automatic framework detection
- Priority-based detection order
- Manual override support
- Fallback to standalone

#### Unified API

**Both Sides:**
- `Framework.Init()` - Initialize framework
- `Framework.Notify()` - Send notifications
- `Framework.Active` - Current framework name
- `Framework.Core` - Framework core object

**Server-Side:**
- `Framework.GetPlayer(source)` - Get player object
- `Framework.GetPlayerMoney(source)` - Get player money
- `Framework.AddMoney(source, amount)` - Add money
- `Framework.RemoveMoney(source, amount)` - Remove money
- `Framework.GetPlayerIdentifier(source)` - Get player ID
- `Framework.GetPlayerName(source)` - Get full name
- `Framework.GetPlayerFirstName(source)` - Get first name
- `Framework.GetPlayerLastName(source)` - Get last name
- `Framework.RegisterCallback(name, cb)` - Register callback
- `Framework.SendWebhook(title, message, color)` - Send Discord webhook

**Client-Side:**
- `Framework.TriggerCallback(name, cb, ...)` - Trigger server callback

---

## Supported Frameworks

| Framework | Detection | Status |
|-----------|-----------|--------|
| LXR-Core | Auto | Primary |
| RSG-Core | Auto | Primary |
| VORP Core | Auto | Supported |
| RedEM:RP | Auto | Optional |
| QBR-Core | Auto | Optional |
| QR-Core | Auto | Optional |
| Standalone | Fallback | Always |

---

## How It Works

### Automatic Detection

```lua
1. Check Config.Framework setting
   ├─ If 'auto': Run detection
   └─ Otherwise: Use manual setting

2. Try frameworks in priority order:
   ├─ lxr-core
   ├─ rsg-core
   ├─ vorp_core
   ├─ redem_roleplay
   ├─ qbr-core
   ├─ qr-core
   └─ standalone (fallback)

3. Load framework core object
4. Initialize adapter functions
```

### Usage Example

```lua
-- Anywhere in client or server code:
Framework.Notify(source, "Ticket purchased!", 5000, 'success')

-- Server-side:
local money = Framework.GetPlayerMoney(source)
Framework.RemoveMoney(source, Config.Tickets.price)

-- Client-side:
Framework.TriggerCallback('lottery:getMoney', function(money)
    print('Player has $' .. money)
end)
```

---

## Benefits

### For Script Developers

- **Single API**: Write once, works everywhere
- **Framework Agnostic**: Core logic doesn't know about frameworks
- **Easy Maintenance**: Update adapter, not entire script
- **Extensible**: Add new frameworks easily

### For Server Owners

- **No Configuration**: Auto-detection "just works"
- **Framework Flexibility**: Switch frameworks without changing lottery script
- **Future-Proof**: New framework support added via adapter updates
- **Backward Compatible**: Legacy frameworks still supported

### For Players

- **Consistent Experience**: Same interface across frameworks
- **Reliable**: Tested across multiple frameworks
- **Fast**: Optimized for each framework's strengths

---

## Adding a New Framework

To add support for a new framework:

1. **Add to Config** (config.lua):
   ```lua
   Config.FrameworkSettings['new-framework'] = {
       resource = 'new-framework',
       notifications = 'notification-system',
       -- ... other settings
   }
   ```

2. **Update Adapter** (shared/framework.lua):
   ```lua
   -- In Framework.Init()
   elseif Framework.Active == 'new-framework' then
       Framework.Core = exports['new-framework']:GetCoreObject()
   
   -- In each adapter function
   elseif Framework.Active == 'new-framework' then
       -- Framework-specific implementation
   ```

3. **Test Thoroughly**:
   - Test all adapter functions
   - Verify notifications work
   - Test money operations
   - Verify callbacks function
   - Test in-game

---

## Troubleshooting

### Framework Not Detected

**Problem:** Script defaults to standalone

**Solutions:**
1. Verify framework resource is started
2. Check framework is loaded before lottery
3. Try manual setting: `Config.Framework = 'your-framework'`
4. Enable debug: `Config.Debug = true`

### Notifications Not Working

**Problem:** No notifications appear

**Solutions:**
1. Check notification system is loaded (ox_lib, etc.)
2. Verify framework adapter has correct notification settings
3. Test with different notification type
4. Check F8 console for errors

### Money Operations Failing

**Problem:** Money not added/removed

**Solutions:**
1. Verify player object is valid
2. Check framework's money system is working
3. Test in standalone framework
4. Review database transactions

---

## Best Practices

1. **Always use adapter** - Don't directly call framework functions
2. **Check return values** - Handle nil cases
3. **Log errors** - Help debugging
4. **Document changes** - Track adapter modifications
5. **Test thoroughly** - Verify across frameworks
6. **Maintain compatibility** - Don't break existing functionality

---

## Configuration Access

The shared config (config.lua) is also accessible on both sides:

```lua
-- Access config anywhere:
local ticketPrice = Config.Tickets.price
local locations = Config.LotteryStations
```

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
