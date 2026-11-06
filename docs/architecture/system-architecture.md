# MODULUS OS — System Architecture

## 1. Architectural style

Layered architecture with strict dependency direction: higher layers depend on lower layers; lower layers never depend on higher layers. Each first-party service has a defined responsibility, documented interface, explicit dependencies, configuration, logging, error handling, tests, versioning and permission boundaries.

## 2. Layers

### Layer 1 — Linux foundation (upstream, unmodified unless required)

- Linux kernel (upstream, with Fedora's config)
- Hardware drivers and firmware
- Process scheduling, memory management, filesystems
- Networking stack, audio infrastructure (PipeWire)
- systemd as init/service manager

**Rule:** No custom kernel. No replacement of kernel subsystems without a demonstrated requirement (Principle 3.2).

### Layer 2 — System infrastructure

- systemd (service management)
- D-Bus (IPC)
- Polkit (authorization)
- Configuration management (documented schemas)
- Logging (journald + structured service logs)
- Update infrastructure (rpm-ostree/bootc)
- Package management (rpm-ostree + Flatpak)
- Hardware detection (udev, /sys)
- Recovery infrastructure (rollback, recovery image)

### Layer 3 — MODULUS core services (first-party)

| Service | Responsibility | Key dependencies |
|---|---|---|
| AdaptiveCore | Resource coordination: profiles, game detection, CPU/mem/GPU awareness | systemd, cgroups, powerprofilesctl, Layer 2 |
| GPUCore | GPU detection, driver info, hybrid graphics | udev, /sys, PCI DB |
| SecureCore | Security integration layer: scanning, firewall, permissions, integrity | ClamAV, firewalld/nftables, SELinux, TPM |
| WallpaperCore | Live wallpaper engine + adaptive rendering | AdaptiveCore, compositor |
| Update Manager | Thin wrapper over rpm-ostree/bootc + Flatpak updates | rpm-ostree, Flatpak, Polkit |
| Hardware Compatibility Service | Device inventory + compatibility DB | udev, /sys, DMI |
| Diagnostics Service | System health, logs, reports | journald, Layer 2 |
| System Configuration Service | Centralized config store + schema validation | D-Bus, Polkit |
| (Game Services) | Game session tracking, per-game config | AdaptiveCore, GPUCore |

### Layer 4 — Desktop experience

- Desktop shell (KDE Plasma 6 customized, not forked)
- Window management (KWin)
- Application launcher, taskbar, system tray
- Notifications, quick settings
- Control Center (unified settings)
- Login experience (SDDM)
- Animation system (KWin effects + Modulus spec)
- Widget framework

### Layer 5 — Applications (first-party)

Game launcher (Modulus Play), Software Center, Terminal, System Monitor, Security Center, Display Manager, Settings, Recovery utility, File manager (Dolphin, customized), Browser (Firefox/Brave default).

## 3. Data flow (typical)

User action in UI → D-Bus call to service → service validates via Polkit → service performs action via upstream mechanism → service emits D-Bus signal → UI updates. No privileged code runs in the UI process.

## 4. Privilege model

- UI processes run as the user.
- System services run as dedicated system users or root only where unavoidable, with tight D-Bus/Polkit policies.
- All privileged operations are exposed as D-Bus methods gated by Polkit actions with defined authorization levels (admin/user/no).
- Audit logging for privileged actions.

See `docs/architecture/privilege-boundaries.md`.

## 5. Configuration model

- One System Configuration Service owns the canonical config.
- Schemas are versioned and documented.
- UI and CLI both call the same service (no duplicated logic — Part 13).
- Config changes are transactional where possible.

## 6. Update/rollback model

- Base OS: image-based (rpm-ostree/bootc), signed, atomic, with rollback.
- Applications: Flatpak, per-user or system.
- Dev tools: optional Homebrew (deferred).
- Interrupted updates must be recoverable (tested in recovery tests).

See `docs/architecture/update-rollback-architecture.md`.

## 7. Observability

- All services log to journald with structured fields.
- A Diagnostics Service aggregates health + logs into a user-facing report.
- Performance metrics (boot time, memory, etc.) collected for benchmarking (Principle 3.5).

## 8. Non-goals (architecture level)

- No custom kernel.
- No fork of Plasma/KWin.
- No replacement of systemd, D-Bus, Polkit, PipeWire, Wayland.
- No per-app custom configuration logic outside the System Configuration Service.