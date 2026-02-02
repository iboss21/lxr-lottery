# 🐺 LXR Lottery System - Performance Optimization

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Performance Overview

LXR Lottery is designed for **minimal server overhead** and **client FPS impact**. This document covers optimization strategies and configuration options.

---

## Performance Configuration

```lua
Config.Performance = {
    updateInterval = 2000,          -- Update frequency (ms)
    cleanupOldWinners = true,       -- Auto-cleanup old records
    cleanupAfterDays = 30,          -- Days to keep records
    cacheTimeout = 300000,          -- Cache duration (5 min)
    usePromptGroups = true          -- Optimized prompts
}
```

---

## Server-Side Optimization

### 1. Database Query Optimization

**Efficient Queries:**
```lua
-- ✅ GOOD: Indexed query with limit
MySQL.query('SELECT * FROM `mms_lotteryticket` WHERE identifier = ? LIMIT 1', 
    {identifier}, 
    function(result) end
)

-- ❌ BAD: Full table scan
MySQL.query('SELECT * FROM `mms_lotteryticket`', {}, function(result)
    -- Processes all rows unnecessarily
end)
```

**Indexing:**
```sql
-- Add indexes to frequently queried columns
CREATE INDEX idx_identifier ON mms_lotteryticket(identifier);
CREATE INDEX idx_won_at ON mms_lotterywinner(won_at);
```

---

### 2. Update Interval Optimization

**Current Implementation:**
```lua
CreateThread(function()
    while true do
        Wait(Config.Performance.updateInterval)  -- 2000ms default
        
        -- Get jackpot
        MySQL.query('SELECT `money` FROM `mms_lotteryjackpot` WHERE jackpot = ?', 
            {'pricemoney'}, 
            function(result)
                if result[1] then
                    local jackpotmoney = result[1].money
                    for _, player in ipairs(GetPlayers()) do
                        TriggerClientEvent('mms-lottery:client:updatejackpot', player, jackpotmoney)
                    end
                end
            end
        )
    end
end)
```

**Optimization Tips:**
- **Higher interval = less load**: 2000-5000ms recommended
- **Only update active players**: Track who has menu open
- **Batch updates**: Update all players in one query result

**Optimized Version:**
```lua
local activeMenuPlayers = {}

CreateThread(function()
    while true do
        Wait(Config.Performance.updateInterval)
        
        if #activeMenuPlayers > 0 then  -- Only if someone has menu open
            MySQL.query('SELECT `money` FROM `mms_lotteryjackpot` WHERE jackpot = ?', 
                {'pricemoney'}, 
                function(result)
                    if result[1] then
                        local jackpot = result[1].money
                        for _, playerId in ipairs(activeMenuPlayers) do
                            TriggerClientEvent('mms-lottery:client:updatejackpot', playerId, jackpot)
                        end
                    end
                end
            )
        end
    end
end)
```

---

### 3. Timer System Optimization

**Efficient Timer Management:**
```lua
-- Store timer in memory, sync to DB periodically
local timer = 0
local lastDbSync = 0

CreateThread(function()
    -- Load timer from DB on start
    local result = MySQL.query.await("SELECT * FROM mms_lotterytimer", {})
    if #result > 0 then
        timer = result[1].timer
    else
        timer = Config.Winner.pickTimeMinutes * 60
    end
    
    while true do
        Wait(2000)
        timer = timer - 2
        
        -- Only sync to DB every 30 seconds
        if os.time() - lastDbSync >= 30 then
            MySQL.update('UPDATE `mms_lotterytimer` SET timer = ?', {timer})
            lastDbSync = os.time()
        end
        
        -- Check for winner
        if timer <= 0 then
            TriggerEvent('mms-lottery:server:pickwinner')
            timer = Config.Winner.pickTimeMinutes * 60
        end
    end
end)
```

**Benefits:**
- Reduces DB writes from every 2 seconds to every 30 seconds
- Maintains accuracy
- Reduces database load

---

### 4. Database Cleanup

**Automatic Old Data Removal:**
```lua
if Config.Performance.cleanupOldWinners then
    CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval or 300000)  -- 5 minutes
            
            local daysAgo = Config.Performance.cleanupAfterDays or 30
            MySQL.execute('DELETE FROM `mms_lotterywinner` WHERE `won_at` < DATE_SUB(NOW(), INTERVAL ? DAY)', 
                {daysAgo}
            )
        end
    end)
end
```

**Benefits:**
- Prevents database bloat
- Improves query performance
- Maintains reasonable history

---

## Client-Side Optimization

### 1. Interaction Distance Check

**Optimized Distance Checking:**
```lua
CreateThread(function()
    while true do
        local sleep = 1000  -- Start with long sleep
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearLottery = false
        
        for _, station in pairs(Config.LotteryStations) do
            local dist = #(playerCoords - station.coords)
            
            if dist < 50.0 then  -- Pre-check
                nearLottery = true
                sleep = 500  -- Reduce sleep when near
                
                if dist < Config.General.interactionDistance then
                    sleep = 0  -- Process every frame when very close
                    -- Show prompt, 3D text, etc.
                end
            end
        end
        
        Wait(sleep)  -- Dynamic sleep based on proximity
    end
end)
```

**Benefits:**
- Reduces CPU usage when far from lottery locations
- More responsive when near
- Minimal FPS impact

---

### 2. NPC & Blip Management

**Efficient Spawning:**
```lua
local spawnedNPCs = {}
local spawnedBlips = {}

-- Only spawn once on resource start
CreateThread(function()
    if Config.General.enableNPCs then
        for _, station in pairs(Config.LotteryStations) do
            local npc = CreatePed(
                GetHashKey(Config.General.npcModel),
                station.coords.x, station.coords.y, station.coords.z - 1,
                station.NpcHeading, false, false
            )
            
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(npc, true)
            
            table.insert(spawnedNPCs, npc)
        end
    end
    
    if Config.General.enableBlips then
        for _, station in pairs(Config.LotteryStations) do
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.coords)
            SetBlipSprite(blip, GetHashKey(station.blipSprite or 'blip_shop_store'), true)
            table.insert(spawnedBlips, blip)
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, npc in ipairs(spawnedNPCs) do
            DeleteEntity(npc)
        end
        for _, blip in ipairs(spawnedBlips) do
            RemoveBlip(blip)
        end
    end
end)
```

---

### 3. Menu Update Optimization

**Only Update When Menu Open:**
```lua
local menuOpen = false

RegisterNetEvent('FeatherMenu:opened')
AddEventHandler('FeatherMenu:opened', function(menudata)
    if menudata.menuid == 'lotterymenu' then
        menuOpen = true
        -- Tell server we need updates
        TriggerServerEvent('lxr-lottery:server:registerMenuUser', true)
    end
end)

RegisterNetEvent('FeatherMenu:closed')
AddEventHandler('FeatherMenu:closed', function(menudata)
    if menudata.menuid == 'lotterymenu' then
        menuOpen = false
        -- Tell server we don't need updates
        TriggerServerEvent('lxr-lottery:server:registerMenuUser', false)
    end
end)

-- Only process updates when menu is open
RegisterNetEvent('mms-lottery:client:updatejackpot')
AddEventHandler('mms-lottery:client:updatejackpot', function(jackpot)
    if menuOpen then
        -- Update display
    end
end)
```

---

## Network Optimization

### 1. Reduce Event Frequency

**Batch Updates:**
```lua
-- Instead of sending updates to each player individually
for _, player in ipairs(GetPlayers()) do
    TriggerClientEvent('update', player, data)  -- Many network calls
end

-- Send once, let client filter
TriggerClientEvent('update', -1, data)  -- One network call
```

---

### 2. Compress Data

**Send Minimal Data:**
```lua
-- ❌ BAD: Send entire player object
TriggerClientEvent('update', source, playerObject)

-- ✅ GOOD: Send only what's needed
TriggerClientEvent('update', source, {
    money = playerObject.money,
    name = playerObject.name
})
```

---

## Performance Monitoring

### 1. Built-in Profiling

**Use FiveM's resmon:**
1. Start server
2. Connect to server
3. Open F8 console
4. Type: `resmon`
5. Look for `lxr-lottery`

**Target Metrics:**
- **Server:** < 0.1ms average
- **Client:** < 0.05ms average
- **Memory:** < 5MB

---

### 2. Custom Profiling

**Add Performance Markers:**
```lua
if Config.Debug then
    local startTime = GetGameTimer()
    
    -- Your code here
    
    local endTime = GetGameTimer()
    print(string.format('[LXR-Lottery] Operation took %dms', endTime - startTime))
end
```

---

### 3. Database Query Timing

**Log Slow Queries:**
```lua
local startTime = os.clock()

MySQL.query('SELECT ...', {}, function(result)
    local queryTime = (os.clock() - startTime) * 1000
    
    if queryTime > 100 then  -- Slower than 100ms
        print(string.format('[LXR-Lottery] SLOW QUERY: %dms', queryTime))
    end
end)
```

---

## Optimization Checklist

### Server

- ✅ Update interval ≥ 2000ms
- ✅ Database queries use indexes
- ✅ Old data cleanup enabled
- ✅ Timer syncs every 30s (not every 2s)
- ✅ Only update players with menu open
- ✅ Use batch database operations
- ✅ Limit event frequency

### Client

- ✅ Dynamic sleep based on distance
- ✅ NPCs spawn once, not repeatedly
- ✅ Blips managed efficiently
- ✅ Menu updates only when open
- ✅ Avoid unnecessary calculations
- ✅ Clean up on resource stop

### Database

- ✅ Indexes on identifier columns
- ✅ Indexes on date columns
- ✅ Regular cleanup of old data
- ✅ Optimize query patterns
- ✅ Use connection pooling (oxmysql)

### Network

- ✅ Minimize event frequency
- ✅ Compress data payloads
- ✅ Batch operations when possible
- ✅ Use state bags for static data

---

## Common Performance Issues

### Issue: High Server ms

**Symptoms:**
- Server resmon shows high ms
- Server lag during lottery events

**Solutions:**
1. Increase update intervals
2. Optimize database queries
3. Add database indexes
4. Reduce unnecessary logging
5. Profile and identify bottlenecks

---

### Issue: Client FPS Drops

**Symptoms:**
- FPS drops near lottery locations
- Stuttering when opening menu

**Solutions:**
1. Optimize distance checks
2. Reduce 3D text draw frequency
3. Optimize NPC spawning
4. Reduce particle effects
5. Use lower quality models

---

### Issue: Database Lag

**Symptoms:**
- Slow ticket purchases
- Delayed winner selection
- Connection timeouts

**Solutions:**
1. Add database indexes
2. Optimize query patterns
3. Enable query caching
4. Clean up old data
5. Upgrade database server

---

### Issue: Memory Leaks

**Symptoms:**
- Memory usage increases over time
- Server crashes after hours

**Solutions:**
1. Clean up event handlers
2. Remove unused variables
3. Clear cached data periodically
4. Profile memory usage
5. Fix circular references

---

## Best Practices

1. **Test with many players** - Simulate high load
2. **Monitor regularly** - Check resmon daily
3. **Profile changes** - Measure before/after optimizations
4. **Keep it simple** - Don't over-complicate
5. **Cache wisely** - Balance freshness vs performance
6. **Clean up** - Remove old data regularly
7. **Update dependencies** - Keep frameworks updated
8. **Document changes** - Track what affects performance
9. **Use profilers** - Don't guess, measure
10. **Ask for help** - Community can assist

---

## Performance Targets

### Recommended Targets

| Metric | Target | Good | Acceptable | Poor |
|--------|--------|------|------------|------|
| Server ms | < 0.05 | < 0.10 | < 0.20 | > 0.20 |
| Client ms | < 0.02 | < 0.05 | < 0.10 | > 0.10 |
| Memory (MB) | < 2 | < 5 | < 10 | > 10 |
| DB Query (ms) | < 10 | < 50 | < 100 | > 100 |
| Network (KB/s) | < 1 | < 5 | < 10 | > 10 |

---

## Troubleshooting Performance

If experiencing performance issues:

1. **Enable profiling:**
   ```lua
   Config.Debug = true
   ```

2. **Check resmon** in-game (F8 → resmon)

3. **Review logs** for slow queries

4. **Test with minimal config:**
   - 1 lottery location
   - Longer update intervals
   - Disable webhooks

5. **Isolate the issue:**
   - Disable other resources
   - Test on clean server
   - Compare with default config

6. **Get community help:**
   - Discord: https://discord.gg/CrKcWdfd3A
   - Provide: resmon screenshot, config, log excerpt

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
