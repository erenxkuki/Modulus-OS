# MODULUS OS — Configuration Schemas

All configuration is owned by the System Configuration Service. Schemas are versioned (v1). UI and CLI both go through the service; no direct file reads.

## Storage

- System-wide: `/etc/modulus/config.toml` (root-owned, service-managed).
- Per-user overrides: `~/.config/modulus/config.toml`.
- Service state (not user config): `/var/lib/modulus/`.

## Top-level keys

### [system]
- `version` (string) — schema version.
- `hostname` (string)
- `locale` (string)
- `timezone` (string)

### [desktop]
- `theme` (string): light | dark | auto
- `accent` (string): hex color
- `reduced_motion` (bool)
- `animation_quality` (string): low | medium | high
- `wallpaper` (string): path or "default"

### [adaptive]
- `auto_mode` (bool)
- `profile` (string): Daily | Gaming | Performance | Silent
- `game_detection` (bool)
- `restore_on_crash` (bool) — must be true

### [gaming]
- `steam_integration` (bool)
- `default_proton` (string)
- `performance_overlay` (bool)
- `gaming_mode_ui` (bool) — opt-in fullscreen interface

### [gpu]
- `hybrid_policy` (string): auto | igpu | dgpu
- `per_app` (table): appId -> gpu

### [security]
- `realtime_scan` (bool)
- `firewall_enabled` (bool)
- `secure_boot` (bool, read-only detected)
- `disk_encryption` (bool, read-only detected)

### [wallpaper]
- `engine_enabled` (bool)
- `pause_on_fullscreen` (bool)
- `pause_on_battery` (bool)
- `quality` (string): low | medium | high

### [updates]
- `auto_check` (bool)
- `auto_download` (bool)
- `apply_requires_confirmation` (bool) — default true

### [privacy]
- `telemetry` (bool) — default false
- `diagnostic_sharing` (bool) — default false

## Validation

- Every key has a JSON schema in `/usr/share/modulus/schemas/`.
- Service rejects invalid values with `org.modulus.Error.InvalidArgument`.
- Unknown keys are rejected (no silent acceptance).
- Migrations: when schema version bumps, a migration script runs on first boot.