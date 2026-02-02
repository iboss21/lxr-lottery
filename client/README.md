# 🐺 Client Scripts

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

This directory contains client-side scripts responsible for:

- **Player Interaction**: NPC prompts, 3D text, interaction detection
- **UI Management**: Lottery menu display and updates
- **Visual Elements**: NPCs, blips, prompts
- **Client Events**: Handling server updates and user actions
- **Framework Integration**: Client-side framework adapter usage

---

## Files

### client.lua

Main client-side script handling:
- Lottery location setup (NPCs, blips, prompts)
- Menu system integration
- Player interaction detection
- Jackpot and timer display updates
- Ticket purchase initiation
- Winnings claim requests
- Resource cleanup on stop

---

## Key Features

### NPC & Blip Spawning
- Spawns lottery vendor NPCs at configured locations
- Creates map blips for easy navigation
- Configurable models and sprites

### Interaction System
- Distance-based prompt display
- 3D text labels (optional)
- Optimized performance with dynamic sleep

### Menu Management
- Opens/closes lottery menu
- Real-time jackpot updates
- Countdown timer display
- Button handlers for actions

### Framework Compatibility
- Uses framework adapter for notifications
- Supports multiple menu systems
- Adapts to different frameworks automatically

---

## Performance Considerations

- **Dynamic Sleep**: Reduces CPU usage when far from locations
- **One-time Spawning**: NPCs and blips spawn once, not repeatedly
- **Event Optimization**: Only processes updates when menu is open
- **Cleanup**: Removes all entities on resource stop

---

## Dependencies

Depends on framework-specific resources:
- **VORP**: bcc-utils, feather-menu
- **LXR/RSG**: ox_lib
- **Others**: Check framework documentation

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
