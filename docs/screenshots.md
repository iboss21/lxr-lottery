# 🐺 LXR Lottery System - Screenshots & Visual Documentation

```
██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

---

## Screenshot Requirements

To properly document and showcase the LXR Lottery System, the following screenshots are required:

---

## Required Screenshots

### 1. Startup Console (01_startup_console.png)

**What to capture:**
- Server console output showing:
  - LXR Lottery ASCII banner
  - Framework detection message
  - Configuration summary
  - Load success message

**Purpose:** Demonstrates successful installation and configuration

**How to capture:**
1. Start your RedM server
2. Wait for lottery system to load
3. Scroll up to see full startup banner
4. Screenshot the console window

**Expected output should include:**
```
═══════════════════════════════════════════════════════════════
    ██╗     ██╗  ██╗██████╗        ██╗      ██████╗ ████████╗
    ...
═══════════════════════════════════════════════════════════════
🐺 LOTTERY SYSTEM - SUCCESSFULLY LOADED
═══════════════════════════════════════════════════════════════

Version:     2.0.0
Server:      The Land of Wolves 🐺
Framework:   vorp_core
...
```

---

### 2. Configuration Sections (02_config_sections.png)

**What to capture:**
- config.lua file open in code editor showing:
  - ASCII header
  - Resource name protection
  - Main configuration sections with banners
  - Boot banner at end

**Purpose:** Shows the professional organization and branding

**How to capture:**
1. Open config.lua in VS Code or similar
2. Scroll to show header and key sections
3. Screenshot showing the banners and structure

---

### 3. UI Interaction (03_ui_interaction.png)

**What to capture:**
- In-game lottery menu showing:
  - Menu header
  - Current jackpot display
  - Timer countdown
  - Buy ticket button
  - Claim winnings button
  - Close button

**Purpose:** Demonstrates the player-facing interface

**How to capture:**
1. Launch RedM and connect to server
2. Approach a lottery location
3. Open the lottery menu
4. Screenshot the menu interface

---

### 4. In-Game Locations (04_lottery_locations.png)

**What to capture:**
- Map view showing:
  - Lottery blips on map
  - Multiple lottery locations
- Or in-game view showing:
  - Lottery NPC
  - 3D text label
  - Interaction prompt

**Purpose:** Shows the lottery locations and how players find them

**How to capture:**
1. Open in-game map (or approach lottery NPC)
2. Zoom to show multiple lottery blips
3. Screenshot the map view
4. Or screenshot player approaching NPC with prompt visible

---

### 5. Discord Logs (05_discord_logs.png)

**What to capture:**
- Discord channel showing:
  - Winner announcement webhook
  - No winner announcement webhook
  - Proper formatting and branding

**Purpose:** Demonstrates webhook integration

**How to capture:**
1. Configure Discord webhook in config
2. Wait for lottery draw or trigger manually
3. Check Discord channel
4. Screenshot the webhook messages

---

### 6. Framework Detection (06_framework_detection.png)

**What to capture:**
- Server console or in-game showing:
  - Framework detection message
  - Successful framework initialization
  - Debug info (if Config.Debug = true)

**Purpose:** Shows multi-framework support in action

**How to capture:**
1. Enable Config.Debug = true
2. Start server
3. Check console for framework detection
4. Screenshot the detection messages

---

### 7. TxAdmin Performance (07_txadmin_performance.png)

**What to capture:**
- TxAdmin performance monitor showing:
  - lxr-lottery resource
  - Low CPU usage (< 0.1ms average)
  - Low memory usage (< 5MB)
  - Healthy status

**Purpose:** Demonstrates optimized performance

**How to capture:**
1. Open TxAdmin performance monitor
2. Let server run for a few minutes
3. Find lxr-lottery in resource list
4. Screenshot showing metrics

**Alternative:** Use in-game resmon (F8 → resmon)

---

### 8. Database Tables (08_database_tables.png) [Optional]

**What to capture:**
- Database management tool (phpMyAdmin, HeidiSQL, etc.) showing:
  - mms_lotteryticket table
  - mms_lotteryjackpot table
  - mms_lotterywinner table
  - mms_lotterytimer table
  - Example data

**Purpose:** Shows database structure

---

### 9. Notification Examples (09_notifications.png) [Optional]

**What to capture:**
- In-game notifications showing:
  - Ticket purchased notification
  - Insufficient funds notification
  - Winner announcement notification
  - Winnings claimed notification

**Purpose:** Shows the notification system

---

## Screenshot Storage

All screenshots should be stored in:
```
/docs/assets/screenshots/
```

### File Naming Convention

- Use descriptive filenames with numbers
- PNG format preferred (or JPEG for large files)
- Keep filenames lowercase with underscores

**Example:**
```
01_startup_console.png
02_config_sections.png
03_ui_interaction.png
04_lottery_locations.png
05_discord_logs.png
06_framework_detection.png
07_txadmin_performance.png
08_database_tables.png (optional)
09_notifications.png (optional)
```

---

## Screenshot Guidelines

### Technical Specifications

- **Resolution:** Minimum 1920x1080 (Full HD)
- **Format:** PNG (preferred) or JPEG
- **Quality:** High quality, no compression artifacts
- **File Size:** Optimize but maintain clarity

### Content Guidelines

1. **No Sensitive Information:**
   - Hide IP addresses
   - Hide server passwords
   - Hide player personal info
   - Hide API keys/tokens

2. **Clean Interface:**
   - Close unnecessary windows
   - Remove debug overlays (unless showing debug info)
   - Hide personal Discord messages

3. **Clear Visibility:**
   - Proper lighting (not at night if hard to see)
   - Clear text (readable font sizes)
   - Good camera angles

4. **Professional Presentation:**
   - Organized desktop
   - Proper window sizing
   - Clear focus on subject

---

## Creating Your Screenshots

### Step-by-Step Process

1. **Install and configure** LXR Lottery on your test server

2. **Configure properly:**
   ```lua
   Config.Lang = 'en'  -- Use English for screenshots
   Config.Webhook.enabled = true  -- Enable for Discord screenshot
   Config.Debug = true  -- Enable for detection screenshot
   ```

3. **Take startup console screenshot:**
   - Restart server
   - Wait for full startup
   - Screenshot console

4. **Take config screenshot:**
   - Open config.lua
   - Show header and main sections
   - Screenshot

5. **Take in-game screenshots:**
   - Connect to server
   - Visit lottery location
   - Open menu
   - Take screenshots of UI, locations, prompts

6. **Take Discord screenshot:**
   - Wait for lottery draw
   - Or manually trigger winner selection
   - Screenshot Discord webhook

7. **Take performance screenshot:**
   - Open TxAdmin or resmon
   - Let server run for stability
   - Screenshot performance metrics

8. **Organize files:**
   ```bash
   mv screenshot1.png docs/assets/screenshots/01_startup_console.png
   mv screenshot2.png docs/assets/screenshots/02_config_sections.png
   # etc...
   ```

---

## Using Screenshots

### In README

```markdown
## Screenshots

### Startup Console
![Startup Console](docs/assets/screenshots/01_startup_console.png)

### Lottery Menu
![Lottery Menu](docs/assets/screenshots/03_ui_interaction.png)

### Discord Integration
![Discord Logs](docs/assets/screenshots/05_discord_logs.png)
```

### In Documentation

Reference screenshots in your documentation:

```markdown
The lottery menu displays the current jackpot and countdown timer:

![Lottery Menu Interface](../assets/screenshots/03_ui_interaction.png)
```

---

## Screenshot Placeholders

Until actual screenshots are captured, you can use placeholder images or text like:

```
[Screenshot Pending: Startup Console]
Shows the LXR Lottery ASCII banner and successful initialization.
```

---

## Community Contributions

If you have high-quality screenshots that would benefit the documentation:

1. Ensure they meet the guidelines above
2. Submit via Discord or GitHub
3. Include description of what's shown
4. Confirm permission to use

---

## Screenshot Tools

### Recommended Tools

**Windows:**
- Greenshot (free, feature-rich)
- ShareX (free, powerful)
- Snipping Tool (built-in)
- Win + Shift + S (built-in)

**Linux:**
- Flameshot (free, excellent)
- GNOME Screenshot (built-in)
- Spectacle (KDE, built-in)

**macOS:**
- Cmd + Shift + 4 (built-in)
- Cmd + Shift + 5 (built-in, advanced)

**In-Game (RedM):**
- F12 (if using Rockstar launcher)
- External capture tools

---

## Post-Processing

### Recommended Edits (Optional)

1. **Crop:** Remove unnecessary borders
2. **Annotate:** Add arrows or circles to highlight features
3. **Blur:** Hide sensitive information
4. **Compress:** Optimize file size without losing quality
5. **Resize:** Maintain aspect ratio, scale if needed

### Tools for Editing

- **GIMP** (free, powerful)
- **Paint.NET** (free, Windows)
- **Photopea** (free, online)
- **Photoshop** (paid, professional)

---

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
