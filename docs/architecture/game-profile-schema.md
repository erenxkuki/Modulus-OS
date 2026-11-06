# MODULUS OS — Game Profile Schema

Per-game configuration stored in System Configuration Service under `gaming.games.<id>`.

## Schema (TOML)

```toml
[gaming.games."steam_12345"]
title = "Example Game"
source = "steam"          # steam | native | heroic | lutris | manual
install_path = "/path/to/game"
executable = "game.exe"
compatibility_runtime = "proton-ge-8-25"   # or "native"
gpu = "auto"              # auto | igpu | dgpu | <pci-id>
adaptive_profile = "Gaming"   # Daily | Gaming | Performance | Silent
env_vars = { DXVK_HUD = "0" }
launch_args = ["-windowed"]
overlay_enabled = true
performance_monitoring = true
created_at = "2026-11-06T00:00:00Z"
last_played = "2026-11-06T00:00:00Z"
total_playtime_seconds = 0
```

## Fields

- `title`: display name.
- `source`: where the game came from.
- `install_path`: absolute path to game directory.
- `executable`: relative path to the launchable.
- `compatibility_runtime`: Proton version or "native".
- `gpu`: which GPU to use (for hybrid laptops).
- `adaptive_profile`: which AdaptiveCore profile to apply on launch.
- `env_vars`: environment variables injected at launch.
- `launch_args`: extra CLI args.
- `overlay_enabled`: show performance overlay.
- `performance_monitoring`: record metrics.

## Launch resolution order

1. Use explicit per-game config if present.
2. Fall back to store-specific defaults (Steam's compatdata, etc.).
3. Fall back to system defaults.

## Restoration

On game exit (normal or abnormal), AdaptiveCore restores the previous profile and desktop effects. Game profile is not mutated by a session.