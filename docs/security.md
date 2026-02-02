# 🐺 LXR Lottery System - Security & Anti-Abuse

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Security Philosophy

LXR Lottery follows a **"Never Trust the Client"** security model. All critical operations are validated server-side with multiple layers of protection against exploits and abuse.

---

## Security Features

### 1. Server-Side Validation

**All critical operations are validated on the server:**

```lua
Config.Security = {
    enabled = true,              -- Master security toggle
    validateDistance = true,     -- Check player distance from lottery location
    maxDistance = 5.0,          -- Maximum allowed distance (meters)
    validateMoney = true,        -- Verify player has sufficient funds
    cooldownBetweenPurchases = 1000,    -- Minimum time between purchases (ms)
    logSuspiciousActivity = true,       -- Log potential exploits
    maxPurchasesPerMinute = 10,        -- Rate limit
    preventDuplicatePurchases = true   -- Prevent rapid duplicates
}
```

---

### 2. Distance Validation

**Prevents players from purchasing tickets remotely.**

**How It Works:**
```lua
-- Server-side validation
local playerCoords = GetEntityCoords(GetPlayerPed(source))
local validDistance = false

for _, station in pairs(Config.LotteryStations) do
    local dist = #(playerCoords - station.coords)
    if dist <= Config.Security.maxDistance then
        validDistance = true
        break
    end
end

if not validDistance then
    -- Reject purchase, log suspicious activity
    return
end
```

**Protection Against:**
- Remote execution exploits
- Teleport-based exploits
- Menu injection attacks

---

### 3. Money Validation

**Double-checks player funds before and during transactions.**

**Validation Points:**
1. **Client-side check** (pre-validation, UX only)
2. **Server-side check** (authoritative)
3. **Framework validation** (using framework's money system)

**Implementation:**
```lua
-- Server-side
local money = Framework.GetPlayerMoney(source)
if money < Config.Tickets.price then
    Framework.Notify(source, Config.Locale[Config.Lang].NotEnoghMoney, 5000, 'error')
    return
end

-- Additional validation before removal
if not Framework.RemoveMoney(source, Config.Tickets.price) then
    -- Money removal failed, abort
    return
end
```

**Protection Against:**
- Money duplication exploits
- Negative money exploits
- Race conditions

---

### 4. Rate Limiting

**Prevents spam and resource abuse.**

**Per-Player Rate Limits:**
```lua
local purchaseCooldowns = {}

-- Check cooldown
if purchaseCooldowns[identifier] then
    local timeSince = os.time() - purchaseCooldowns[identifier]
    if timeSince < Config.Security.cooldownBetweenPurchases / 1000 then
        -- Too fast, reject
        return
    end
end

-- Set new cooldown
purchaseCooldowns[identifier] = os.time()
```

**Configurable Limits:**
- `cooldownBetweenPurchases`: Minimum time between purchases
- `maxPurchasesPerMinute`: Maximum purchases in 60 seconds

**Protection Against:**
- Spam attacks
- DoS attempts
- Exploit automation

---

### 5. Ticket Limits

**Optional per-player ticket limits for fair play.**

**Configuration:**
```lua
Config.Tickets = {
    limitEnabled = true,     -- Enable limits
    maxPerPlayer = 3        -- Max tickets per player per draw
}
```

**Validation:**
```lua
-- Server-side
if Config.Tickets.limitEnabled then
    MySQL.query('SELECT * FROM `mms_lotteryticket` WHERE identifier = ?', {identifier}, function(result)
        if result[1] and result[1].tickets >= Config.Tickets.maxPerPlayer then
            -- Player at limit
            Framework.Notify(source, Config.Locale[Config.Lang].MaxTicketsBought .. Config.Tickets.maxPerPlayer, 5000, 'error')
            return
        end
        -- Allow purchase
    end)
end
```

**Protection Against:**
- Jackpot manipulation
- Unfair advantages
- Economy imbalance

---

### 6. Database Security

**Parameterized queries prevent SQL injection.**

**Good (Safe):**
```lua
MySQL.query('SELECT * FROM `mms_lotteryticket` WHERE identifier = ?', {identifier}, function(result)
    -- Safe from SQL injection
end)
```

**Bad (Vulnerable):**
```lua
-- NEVER DO THIS
MySQL.query('SELECT * FROM `mms_lotteryticket` WHERE identifier = "' .. identifier .. '"', function(result)
    -- VULNERABLE TO SQL INJECTION
end)
```

**Best Practices:**
- Always use parameterized queries (?)
- Never concatenate user input into SQL
- Validate and sanitize all inputs
- Use prepared statements

**Protection Against:**
- SQL injection
- Database manipulation
- Data breaches

---

### 7. Transaction Atomicity

**Ensures consistency in money/ticket operations.**

**Pattern:**
```lua
-- 1. Validate
if not ValidateConditions() then
    return false
end

-- 2. Execute transaction
local success = Framework.RemoveMoney(source, amount)
if not success then
    -- Transaction failed, abort
    return false
end

-- 3. Record in database
MySQL.insert('INSERT INTO ... ', {data}, function()
    -- Only commit after successful execution
end)
```

**Protection Against:**
- Duplication exploits
- Race conditions
- Inconsistent state

---

### 8. Suspicious Activity Logging

**Tracks and logs potential exploits.**

**Logged Events:**
- Failed distance validations
- Excessive purchase attempts
- Invalid money transactions
- Database errors
- Unusual patterns

**Implementation:**
```lua
if Config.Security.logSuspiciousActivity then
    print(string.format('[LXR-Lottery] SECURITY: Player %s attempted purchase from distance %.2f (max: %.2f)', 
        GetPlayerName(source), 
        distance, 
        Config.Security.maxDistance
    ))
end
```

**Log Analysis:**
- Review logs regularly
- Look for patterns
- Identify repeat offenders
- Take appropriate action

---

### 9. Resource Name Protection

**Prevents resource rename exploits.**

**Runtime Check:**
```lua
local REQUIRED_RESOURCE_NAME = "lxr-lottery"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error([[
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        Expected: lxr-lottery
        Got: ]] .. currentResourceName .. [[
        Rename the folder to "lxr-lottery" to continue.
    ]])
end
```

**Protection Against:**
- License bypass attempts
- Script tampering
- Unauthorized modifications

---

## Security Configuration

### Recommended Settings (Production)

```lua
Config.Security = {
    enabled = true,                      -- ✅ ALWAYS ENABLED
    validateDistance = true,             -- ✅ ALWAYS ENABLED
    maxDistance = 5.0,                   -- ✅ Reasonable limit
    validateMoney = true,                -- ✅ ALWAYS ENABLED
    cooldownBetweenPurchases = 1000,    -- ✅ 1 second minimum
    logSuspiciousActivity = true,        -- ✅ ALWAYS ENABLED
    maxPurchasesPerMinute = 10,         -- ✅ Reasonable limit
    preventDuplicatePurchases = true    -- ✅ ALWAYS ENABLED
}
```

### Testing Settings (Development)

```lua
Config.Security = {
    enabled = true,                      -- Keep enabled for testing
    validateDistance = false,            -- Can disable for testing
    maxDistance = 100.0,                 -- Larger for convenience
    validateMoney = true,                -- Keep enabled
    cooldownBetweenPurchases = 100,     -- Shorter for testing
    logSuspiciousActivity = true,        -- Keep enabled
    maxPurchasesPerMinute = 100,        -- Higher for testing
    preventDuplicatePurchases = false   -- Can disable for testing
}
```

**⚠️ NEVER run production with testing settings!**

---

## Common Exploits & Protections

### Exploit: Money Duplication

**Method:** Spamming purchases to create race condition

**Protection:**
- ✅ Server-side money validation
- ✅ Transaction atomicity
- ✅ Rate limiting
- ✅ Cooldown system

---

### Exploit: Remote Execution

**Method:** Triggering events from far away

**Protection:**
- ✅ Distance validation
- ✅ Suspicious activity logging
- ✅ Server-side coordinate checks

---

### Exploit: Ticket Limit Bypass

**Method:** Attempting to exceed ticket limits

**Protection:**
- ✅ Database query validation
- ✅ Server-side limit checking
- ✅ Transaction rollback on violation

---

### Exploit: SQL Injection

**Method:** Injecting malicious SQL in inputs

**Protection:**
- ✅ Parameterized queries
- ✅ Input validation
- ✅ Framework-level protection

---

### Exploit: Menu Injection

**Method:** Injecting malicious code via menus

**Protection:**
- ✅ Server-side validation
- ✅ No client-trusted values
- ✅ Input sanitization

---

## Admin Tools

### Manual Winner Selection (Debug)

```lua
-- Server console
ExecuteCommand('lotterydraw')

-- Implementation
RegisterCommand('lotterydraw', function(source, args)
    if source == 0 or IsPlayerAce(source, 'lottery.admin') then
        TriggerEvent('mms-lottery:server:pickwinner')
        print('Manual lottery draw triggered')
    end
end, true)
```

### Reset Lottery

```lua
RegisterCommand('lotteryreset', function(source, args)
    if source == 0 or IsPlayerAce(source, 'lottery.admin') then
        TriggerEvent('mms-lottery:server:clear')
        print('Lottery reset')
    end
end, true)
```

### View Security Logs

```lua
-- Check server console or log files for:
[LXR-Lottery] SECURITY: ...
```

---

## Security Checklist

Before going live, verify:

- ✅ `Config.Security.enabled = true`
- ✅ `Config.Security.validateDistance = true`
- ✅ `Config.Security.validateMoney = true`
- ✅ `Config.Security.logSuspiciousActivity = true`
- ✅ All rate limits configured appropriately
- ✅ Webhook logging enabled (optional but recommended)
- ✅ Database backups configured
- ✅ Server logs monitoring enabled
- ✅ Admin commands secured with ACE permissions
- ✅ Resource name is exactly "lxr-lottery"
- ✅ No debugging/testing settings enabled

---

## Incident Response

### If Exploit Detected:

1. **Immediate Actions:**
   - Check server logs
   - Identify affected players
   - Check database for anomalies
   - Temporarily disable lottery if needed

2. **Investigation:**
   - Review security logs
   - Check transaction history
   - Identify exploit method
   - Document findings

3. **Remediation:**
   - Patch vulnerability
   - Rollback fraudulent transactions
   - Ban exploiters (if applicable)
   - Update security settings

4. **Prevention:**
   - Update documentation
   - Inform other server owners
   - Report to script developer
   - Enhance monitoring

---

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** publicly disclose it
2. **DO NOT** exploit it
3. **DO** report it privately:
   - Discord: https://discord.gg/CrKcWdfd3A
   - GitHub: https://github.com/iBoss21 (private message)
   - Email: (available on Discord)

4. Include:
   - Detailed description
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

---

## Best Practices

1. **Keep security enabled** - Never disable in production
2. **Monitor logs regularly** - Watch for suspicious patterns
3. **Keep backups** - Database backups before major events
4. **Limit admin access** - Only trusted administrators
5. **Test updates** - Always test in development first
6. **Review permissions** - Regular ACE permission audits
7. **Update regularly** - Keep script and dependencies updated
8. **Document changes** - Track all configuration changes
9. **Educate staff** - Train admins on security practices
10. **Stay informed** - Follow security announcements

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
