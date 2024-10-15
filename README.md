# Damage Display and Hit Marker Script

A FiveM script to display hit markers and remaining health/armor, with support for NPCs and customizable features.

## Features
- **Damage Text**: Shows remaining health/armor after each hit.
- **Hit Marker Sounds**: Plays sounds for hits and headshots.
- **Configurable**: Customize colors, display duration, and more in the config.
- **Support for NPCs**: Optional damage display for NPCs.
- **Real-time Commands**: Set custom limits for damage text display during gameplay.

## Installation
1. Place the script in your `resources` folder.
2. Add `ensure [resource_name]` to your `server.cfg`.
3. Edit `config.lua` to customize behavior.

## Configuration (config.lua)
```lua
Config = {
    HitMarker = true,  -- Enable/Disable hit marker sounds
    ShowNPCDamages = true,  -- Toggle NPC damage display
    EnableDamageText = true,  -- Toggle damage text
    NormalHitColor = {r = 255, g = 0, b = 0},  -- Health text color
    ArmorHitColor = {r = 0, g = 0, b = 255},  -- Armor text color
    NPCHitRepeatLimit = 50,  -- NPC text duration
    PlayerHitRepeatLimit = 200,  -- Player text duration
}
