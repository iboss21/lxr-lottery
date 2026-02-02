# 🐺 LXR Lottery System - Events & API

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Event System Overview

LXR Lottery uses a unified event system that works across all supported frameworks. The framework adapter handles routing events to the correct framework-specific implementations.

---

## Client Events

### mms-lottery:client:openlottery

**Purpose:** Opens the lottery menu

**Usage:**
```lua
TriggerEvent('mms-lottery:client:openlottery')
```

**Parameters:** None

**Example:**
```lua
-- Trigger from another script
TriggerEvent('mms-lottery:client:openlottery')
```

---

### mms-lottery:client:buyticket

**Purpose:** Initiates ticket purchase process

**Usage:**
```lua
TriggerEvent('mms-lottery:client:buyticket')
```

**Flow:**
1. Checks player money via callback
2. Validates sufficient funds
3. Sends purchase request to server
4. Server validates and processes

---

### mms-lottery:client:getwinnings

**Purpose:** Claims lottery winnings

**Usage:**
```lua
TriggerEvent('mms-lottery:client:getwinnings')
```

**Flow:**
1. Sends claim request to server
2. Server checks for unclaimed winnings
3. Adds money to player
4. Removes winner record from database

---

### mms-lottery:client:updatejackpot

**Purpose:** Updates jackpot display in menu

**Triggered By:** Server (automatic)

**Parameters:**
- `jackpotmoney` (number): Current jackpot amount

**Usage:**
```lua
RegisterNetEvent('mms-lottery:client:updatejackpot')
AddEventHandler('mms-lottery:client:updatejackpot', function(jackpotmoney)
    -- Update UI with new jackpot amount
end)
```

---

### mms-lottery:client:updatetimer

**Purpose:** Updates countdown timer in menu

**Triggered By:** Server (automatic, every 2 seconds)

**Parameters:**
- `timeleft` (number): Time remaining in minutes (decimal)

**Usage:**
```lua
RegisterNetEvent('mms-lottery:client:updatetimer')
AddEventHandler('mms-lottery:client:updatetimer', function(timeleft)
    -- Update UI with time remaining
end)
```

---

## Server Events

### mms-lottery:server:buyticket

**Purpose:** Processes ticket purchase

**Triggered By:** Client

**Flow:**
1. Gets player data
2. Validates money
3. Validates ticket limit (if enabled)
4. Removes money from player
5. Adds ticket to database
6. Updates jackpot

**Security:**
- Server-side money validation
- Rate limiting
- Duplicate purchase prevention
- Distance validation (optional)

**Usage:**
```lua
RegisterServerEvent('mms-lottery:server:buyticket')
AddEventHandler('mms-lottery:server:buyticket', function()
    local src = source
    -- Process purchase...
end)
```

---

### mms-lottery:server:getwinnings

**Purpose:** Processes winnings claim

**Triggered By:** Client

**Flow:**
1. Gets player identifier
2. Queries database for unclaimed winnings
3. Validates winner record exists
4. Adds money to player
5. Removes winner record
6. Sends notification

**Security:**
- Server-side validation
- Identifier verification
- Transaction logging

---

### mms-lottery:server:pickwinner

**Purpose:** Selects lottery winner

**Triggered By:** Timer system (automatic)

**Flow:**
1. Queries all tickets from database
2. Randomly selects winner ticket
3. Gets winner information
4. Gets current jackpot amount
5. Inserts winner record
6. Announces winner (optional)
7. Sends Discord webhook (optional)
8. Clears tickets and jackpot

**Timing:**
- Runs automatically based on `Config.Winner.pickTimeMinutes`
- Timer persists across restarts (stored in database)

---

### mms-lottery:server:winner

**Purpose:** Retrieves winner details

**Triggered By:** `mms-lottery:server:pickwinner`

**Parameters:**
- `winnerticketid` (number): ID of winning ticket

**Flow:**
1. Gets ticket information
2. Gets current jackpot
3. Triggers winner insertion

---

### mms-lottery:server:insertwinner

**Purpose:** Records winner and sends announcements

**Triggered By:** `mms-lottery:server:winner`

**Parameters:**
- `winnerfirstname` (string)
- `winneridentifier` (string)
- `winnerlastname` (string)
- `winnerpricemoney` (number)

**Flow:**
1. Sends Discord webhook
2. Announces to all players
3. Inserts winner record
4. Triggers cleanup

---

### mms-lottery:server:clear

**Purpose:** Clears lottery data after winner selection

**Triggered By:** `mms-lottery:server:insertwinner`

**Actions:**
1. Deletes all tickets
2. Deletes jackpot record
3. Resets for next lottery round

---

## Callbacks

### mms-banking:callback:getplayermoney

**Purpose:** Gets player's current money

**Type:** Callback

**Usage:**
```lua
-- Client-side
local Money = VORPcore.Callback.TriggerAwait('mms-banking:callback:getplayermoney')
```

**Returns:** Player's cash amount (number)

**Note:** This callback name is legacy from original script. Consider using Framework.GetPlayerMoney() in new code.

---

## Framework Adapter API

The framework adapter provides unified functions that work across all frameworks:

### Server-Side Functions

```lua
-- Get player money
local money = Framework.GetPlayerMoney(source)

-- Add money to player
Framework.AddMoney(source, amount)

-- Remove money from player
Framework.RemoveMoney(source, amount)

-- Get player identifier
local identifier = Framework.GetPlayerIdentifier(source)

-- Get player name
local fullname = Framework.GetPlayerName(source)
local firstname = Framework.GetPlayerFirstName(source)
local lastname = Framework.GetPlayerLastName(source)

-- Send notification
Framework.Notify(source, message, duration, type)

-- Send Discord webhook
Framework.SendWebhook(title, message, color)

-- Register callback
Framework.RegisterCallback(name, function(source, cb, ...)
    -- Your code
    cb(result)
end)
```

### Client-Side Functions

```lua
-- Send notification
Framework.Notify(message, duration, type)

-- Trigger callback
Framework.TriggerCallback(name, function(result)
    -- Handle result
end, ...)
```

---

## Custom Event Integration

### Opening Lottery Menu from Another Script

```lua
-- From client-side script
TriggerEvent('mms-lottery:client:openlottery')
```

### Manually Triggering Winner Selection

```lua
-- From server-side (admin command, etc.)
TriggerEvent('mms-lottery:server:pickwinner')
```

### Getting Jackpot Amount

```lua
-- Server-side
MySQL.query('SELECT `money` FROM `mms_lotteryjackpot` WHERE jackpot = ?', {'pricemoney'}, function(result)
    if result[1] then
        local jackpot = result[1].money
        -- Use jackpot value
    end
end)
```

### Checking if Player Has Winning Ticket

```lua
-- Server-side
local identifier = Framework.GetPlayerIdentifier(source)
MySQL.query('SELECT * FROM `mms_lotterywinner` WHERE identifier = ?', {identifier}, function(result)
    if result[1] then
        -- Player has unclaimed winnings
        local prize = result[1].pricemoney
    end
end)
```

---

## Event Flow Diagrams

### Ticket Purchase Flow

```
Player Approaches NPC
       ↓
Player Opens Menu
       ↓
Player Clicks "Buy Ticket"
       ↓
mms-lottery:client:buyticket
       ↓
Callback: Check Money
       ↓
[Client Validates] → Sufficient Funds?
       ↓ Yes
mms-lottery:server:buyticket
       ↓
[Server Validates] → Money, Distance, Limits
       ↓ Valid
Remove Money
       ↓
Add Ticket to Database
       ↓
Update Jackpot
       ↓
Send Notification
```

### Winner Selection Flow

```
Timer Reaches Zero
       ↓
mms-lottery:server:pickwinner
       ↓
Query All Tickets
       ↓
Tickets Exist?
  ↓ Yes         ↓ No
Select Random   Announce No Winner
Winner          (optional)
  ↓
mms-lottery:server:winner
  ↓
Get Winner Details
  ↓
mms-lottery:server:insertwinner
  ↓
Send Discord Webhook
  ↓
Announce to Players
  ↓
Insert Winner Record
  ↓
mms-lottery:server:clear
  ↓
Delete Tickets & Jackpot
  ↓
Reset Timer
```

### Winnings Claim Flow

```
Player Opens Menu
       ↓
Player Clicks "Claim Winnings"
       ↓
mms-lottery:client:getwinnings
       ↓
mms-lottery:server:getwinnings
       ↓
Get Player Identifier
       ↓
Query Winner Record
       ↓
Winner Exists?
  ↓ Yes             ↓ No
Add Money           Send "No Winnings" Notification
  ↓
Delete Winner Record
  ↓
Send Success Notification
```

---

## Extending the System

### Adding Custom Events

**Example: Admin Reset Command**

```lua
-- Client-side (admin menu)
RegisterCommand('lotteryreset', function()
    TriggerServerEvent('lxr-lottery:admin:reset')
end, false)

-- Server-side
RegisterServerEvent('lxr-lottery:admin:reset')
AddEventHandler('lxr-lottery:admin:reset', function()
    local src = source
    -- Check if player is admin
    if IsPlayerAdmin(src) then
        TriggerEvent('mms-lottery:server:clear')
        print('Lottery reset by admin')
    end
end)
```

### Adding Winner History

```lua
-- Server-side
RegisterServerEvent('lxr-lottery:getHistory')
AddEventHandler('lxr-lottery:getHistory', function()
    local src = source
    MySQL.query('SELECT * FROM `mms_lotterywinner` ORDER BY `won_at` DESC LIMIT 10', {}, function(result)
        TriggerClientEvent('lxr-lottery:receiveHistory', src, result)
    end)
end)

-- Client-side
RegisterNetEvent('lxr-lottery:receiveHistory')
AddEventHandler('lxr-lottery:receiveHistory', function(history)
    -- Display history in menu
end)
```

### Adding Statistics

```lua
-- Server-side
RegisterServerEvent('lxr-lottery:getStats')
AddEventHandler('lxr-lottery:getStats', function()
    local src = source
    local stats = {
        totalTicketsSold = 0,
        totalJackpotPaid = 0,
        totalDraws = 0
    }
    -- Query statistics from database
    TriggerClientEvent('lxr-lottery:receiveStats', src, stats)
end)
```

---

## Best Practices

1. **Always validate on server** - Never trust client data
2. **Use framework adapter** - For cross-framework compatibility
3. **Handle errors gracefully** - Check for nil values
4. **Log important events** - For debugging and auditing
5. **Rate limit custom events** - Prevent spam/exploits
6. **Document custom events** - For maintainability
7. **Test thoroughly** - Across all frameworks

---

## Troubleshooting Events

### Event Not Firing

**Checklist:**
- ✅ Is the event registered?
- ✅ Is the event name spelled correctly?
- ✅ Is it a client or server event?
- ✅ Are parameters correct?
- ✅ Check F8 console for errors

### Callback Timeout

**Solutions:**
- Verify callback is registered on server
- Check callback name matches
- Ensure callback response (cb) is called
- Check for server-side errors

### Money Not Updating

**Solutions:**
- Verify framework adapter is working
- Check player object is valid
- Verify money operations in framework
- Check database for transaction records

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
