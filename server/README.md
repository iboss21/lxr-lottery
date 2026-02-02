# 🐺 Server Scripts

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

This directory contains server-side scripts responsible for:

- **Database Management**: Ticket, jackpot, winner, and timer tables
- **Money Transactions**: Secure server-side money handling
- **Winner Selection**: Random winner draw system
- **Timer System**: Persistent countdown timer
- **Security Validation**: Distance, money, rate limiting
- **Webhook Integration**: Discord announcements
- **Framework Integration**: Server-side framework adapter usage

---

## Files

### server.lua

Main server-side script handling:
- Version checking
- Database operations (tickets, jackpot, winners, timer)
- Winner selection algorithm
- Ticket purchase processing
- Money validation and transactions
- Winnings claim processing
- Discord webhook notifications
- Timer countdown and persistence
- Player callbacks
- Security enforcement

---

## Key Features

### Database Operations
- **Tickets**: Stores player lottery tickets with limits
- **Jackpot**: Tracks growing jackpot amount
- **Winners**: Records winner history
- **Timer**: Persists countdown across restarts

### Winner Selection
- Random selection from all tickets
- Announces winner to server
- Sends Discord webhook (optional)
- Clears tickets and jackpot
- Resets timer for next round

### Security
- Server-side money validation
- Distance checks (anti-exploit)
- Rate limiting on purchases
- Ticket limit enforcement
- Transaction logging

### Timer System
- Persistent across server restarts
- Stored in database
- Countdown in real-time
- Automatic winner selection at zero

### Webhook Integration
- Winner announcements
- No winner notifications
- Customizable formatting
- Framework-compatible

---

## Security Measures

### Money Validation
```lua
1. Check player has sufficient funds
2. Validate framework money system
3. Remove money server-side
4. Record transaction
5. Rollback on failure
```

### Distance Validation
```lua
1. Get player coordinates
2. Calculate distance to lottery locations
3. Reject if > max distance
4. Log suspicious activity
```

### Rate Limiting
```lua
1. Track last purchase time per player
2. Enforce cooldown
3. Limit purchases per minute
4. Prevent spam/exploits
```

---

## Database Schema

### mms_lotteryticket
- `id`: Auto-increment primary key
- `identifier`: Player identifier
- `firstname`: Player first name
- `lastname`: Player last name
- `tickets`: Number of tickets (for limits)

### mms_lotteryjackpot
- `jackpot`: Fixed value 'pricemoney'
- `money`: Current jackpot amount

### mms_lotterywinner
- `id`: Auto-increment primary key
- `identifier`: Winner identifier
- `firstname`: Winner first name
- `lastname`: Winner last name
- `pricemoney`: Prize amount
- `won_at`: Timestamp

### mms_lotterytimer
- `id`: Auto-increment primary key
- `timer`: Time remaining (seconds)

---

## Performance Optimization

- **Query Optimization**: Indexed columns, efficient queries
- **Update Intervals**: Configurable (default 2000ms)
- **Batch Operations**: Update all players in one cycle
- **Database Cleanup**: Auto-remove old winner records
- **Timer Caching**: Sync to DB every 30s (not every 2s)

---

## Dependencies

- **oxmysql**: Required for database operations
- **Framework**: One of supported frameworks
- Framework-specific exports and functions

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
