# MODULUS OS — Roadmap

Phases per master spec Part 22. A phase is complete only when its acceptance criteria pass.

- **Phase 0 — Research & feasibility** *(current)*: research report, architecture, tech selection, risk register, plan.
- **Phase 1 — Bootable foundation**: installable image, desktop, networking, audio, display, updates, rollback.
- **Phase 2 — Desktop experience**: branding, design system, taskbar, launcher, quick settings, Control Center, login, animations, themes.
- **Phase 3 — AdaptiveCore & GPUCore**: hardware detection, resource monitoring, profiles, GPU/driver info, safe switching.
- **Phase 4 — Modulus Play**: game library, Steam integration, launch configs, AdaptiveCore integration, overlay, controller nav.
- **Phase 5 — SecureCore**: security dashboard, scanning, quarantine, firewall, permissions, integrity, event history.
- **Phase 6 — WallpaperCore & customization**: static/video wallpapers, library, multi-display, adaptive rendering.
- **Phase 7 — Software Center & system utilities**: graphical package mgmt, storage manager, device manager, diagnostics, printers, system monitor.
- **Phase 8 — Compatibility & optimization**: hardware matrix testing, benchmarks.
- **Phase 9 — Release engineering**: signed images, installer, docs, recovery, release notes, known limitations, compat info.

## Immediate next step

Complete Phase 0 review, then run the ADR-0001 validation spike (Phase 1, Task 0). Do not begin implementing subsystems until the foundation decision is validated.