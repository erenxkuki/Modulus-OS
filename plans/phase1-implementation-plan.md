# MODULUS OS — Phase 1 Implementation Plan

**Goal:** A real, installable MODULUS OS image with polished desktop, networking, audio, graphics and updates. This is the foundation everything else depends on.

**Phase gate:** All acceptance criteria in Part 22 Phase 1 must pass.

## Task 0 — Validation spike (blocks everything)

- 0.1 Set up build environment (Fedora host or container with bootc/rpm-ostree tooling).
- 0.2 Build a Kinoite-based image with Modulus branding (name, wallpaper, Plymouth).
- 0.3 Boot in VM (QEMU/KVM) — verify install, network, audio, display.
- 0.4 Boot on one NVIDIA machine, Secure Boot ON — enroll MOK, install NVIDIA drivers, launch Steam + one Proton game.
- 0.5 Test interrupted update (kill mid-staging) → still boots.
- 0.6 Test rollback after a deliberately broken image → restores working system.
- **Exit:** Spike report written; ADR-0001 marked Accepted or revisited.

## Task 1 — Repository & build pipeline

- 1.1 Initialize git repo, monorepo layout per Part 21 (only create dirs when needed).
- 1.2 Containerfile for the image; reproducible build documented.
- 1.3 CI: build image on push; artifact stored.
- 1.4 Versioning scheme (image version = Fedora base + Modulus revision).

## Task 2 — Branding & first-boot

- 2.1 Plymouth theme.
- 2.2 SDDM login theme (Modulus look-and-feel).
- 2.3 Default wallpaper + color scheme (light/dark).
- 2.4 First-boot wizard (user account already via installer; post-install tweaks).

## Task 3 — Desktop baseline (Plasma 6)

- 3.1 Install Plasma 6 + KWin (Wayland) from Fedora.
- 3.2 Apply Modulus look-and-feel package (colors, icons, fonts, window decorations).
- 3.3 Taskbar, launcher, system tray configured.
- 3.4 Reduced-motion / accessibility settings wired.

## Task 4 — Networking, audio, display

- 4.1 NetworkManager + KDE network applet verified.
- 4.2 PipeWire + WirePlumber verified (audio playback/recording).
- 4.3 Display settings (KDE) verified: multi-monitor, scaling, refresh rate.

## Task 5 — Package & update baseline

- 5.1 Flatpak + Flathub configured.
- 5.2 Update Manager (thin wrapper) v0: check + notify + apply base/Flatpak updates.
- 5.3 Rollback entry in boot menu verified.

## Task 6 — Software Center v0

- 5.1 Adopt Bazaar with Modulus branding; verify install/update/remove.

## Task 7 — Testing & docs

- 7.1 Install test in VM (automated where possible).
- 7.2 Hardware test on at least one real machine per GPU vendor available.
- 7.3 Phase 1 acceptance report + update project status.

## Dependencies

0.x → everything. 1 → 2,3,4,5. 3 → 6. 7 last.

## Out of scope for Phase 1

AdaptiveCore, GPUCore, SecureCore, WallpaperCore, Modulus Play, advanced Control Center (basic settings only), live wallpapers, game overlay. Those are Phases 2-6.