# MODULUS OS — Component Dependency Graph

Dependencies flow downward. A component may depend only on components in the same or lower layers.

## Layer 1 (foundation) — no MODULUS deps
- Linux kernel, systemd, D-Bus daemon, Polkit, PipeWire, Wayland/KWin, Mesa/drivers

## Layer 2 (infrastructure) — depends on Layer 1
- Configuration management, logging, update infra, hardware detection, recovery infra

## Layer 3 (core services) — depends on Layer 1+2
- System Configuration Service (base for others)
- Hardware Compatibility Service → System Config, hardware detection
- GPUCore → Hardware Compatibility Service
- AdaptiveCore → System Config, GPUCore, Hardware Compatibility Service
- WallpaperCore → AdaptiveCore
- SecureCore → System Config, Hardware Compatibility Service
- Diagnostics Service → all Layer 3 (read-only aggregation)
- Update Manager → update infra, System Config, Polkit
- Game Services → AdaptiveCore, GPUCore

## Layer 4 (desktop) — depends on Layer 1-3
- Desktop shell → System Config, notifications
- Control Center → System Config, all relevant Layer 3 services
- Animation system → AdaptiveCore (quality hints), GPUCore
- Login → System Config

## Layer 5 (applications) — depends on Layer 1-4
- Modulus Play → Game Services, AdaptiveCore, GPUCore
- Software Center → Update Manager, System Config
- Security Center → SecureCore
- System Monitor → Diagnostics Service, AdaptiveCore
- Settings → Control Center

## Rules
- No circular dependencies. If two services need each other, introduce an event/signal via D-Bus instead of a direct call.
- Layer 3 services must not depend on Layer 4/5.
- All cross-service communication is via D-Bus; no direct library linking between services.