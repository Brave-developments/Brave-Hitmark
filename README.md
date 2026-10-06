# Brave-Hitmark

Dynamic damage display + hit marker sounds for FiveM. Purely client-side — no
framework required.

## Features

- **Hit marker sounds** on every hit (separate headshot sound, toggle via `Config.HitMarker`)
- **3D damage text** showing remaining health/armor next to the target
  (`Config.EnableDamageText`), colors configured per hit type
- Works on players and NPCs (NPC display gated by `Config.ShowNPCDamages`)
- Players and NPCs get separate draw-repeat limits (performance-wise, so a
  spray of hits doesn't redraw the entire duration)

## Commands

| Command | Description |
|---------|-------------|
| `toggledamages` | Enable/disable the damage display for you |
| `setnpclimit <n>` | Change the NPC draw-repeat limit for your session |
| `setplayerlimit <n>` | Change the player draw-repeat limit for your session |

Commands are **client-local** (they only change what YOU see and only your own
draw load). Config defaults live in `config.lua`.

## Installation

1. Drop the resource into your `resources` folder.
2. Add to your `server.cfg`:

```cfg
ensure Brave-Hitmark
```

The NUI page (`index.html` + `sounds/*.ogg`) ships in the repo; nothing extra
to configure.

## License

All rights reserved.
