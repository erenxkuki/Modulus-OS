# MODULUS OS — Phase 0 Research Report

**Phase:** 0 (Research and feasibility)
**Status:** Draft v1 — based on publicly available information; items marked "VERIFY" require hands-on validation.

---

## 1. Executive summary

- The Linux gaming desktop ecosystem has matured significantly. Fedora Atomic-based immutable distributions (Bazzite) and Arch-based rolling systems (SteamOS) are now credible gaming platforms.
- Building MODULUS OS as a **from-scratch distribution is not recommended**. The pragmatic path is to build on an **immutable Fedora Atomic base** and layer first-party services/applications, mirroring the approach that made Bazzite successful.
- KDE Plasma 6 is the most suitable desktop foundation for MODULUS OS given its maturity, multi-monitor support, gaming ecosystem alignment, and extensibility via QML/KCMs.
- The single biggest technical risk is **NVIDIA + Secure Boot + immutable image** interaction. This must be validated in a spike before committing.
- Second biggest risk: scope. The master spec describes ~9 subsystems. We must ship a bootable, polished image (Phase 1) before touching AdaptiveCore/GPUCore/etc.

## 2. Distribution foundation comparison

### 2.1 Candidates

| Base | Update model | Rollback | Gaming readiness | NVIDIA support | Maintenance burden | Notes |
|---|---|---|---|---|---|---|
| Fedora Atomic (Silverblue/Kinoite) | Image-based (rpm-ostree/bootc), atomic | Yes, built-in | High (Bazzite proves it) | Good via RPM Fusion/akmods; Secure Boot needs MOK | Medium | Strong security posture (SELinux), modern kernel, PipeWire default |
| Arch Linux (rolling) | Rolling, per-package | No native (manual snapshots) | High (SteamOS 3.0) | Good, latest drivers | High | Fastest driver/kernel updates; high breakage risk; not ideal for "everyday users" |
| Ubuntu (mutable) | .deb/apt, point releases + LTS | Timeshift (manual) | Medium | Good (proprietary driver manager) | Low-Medium | Largest app ecosystem; mutable base conflicts with "reliable rollback" goal |
| Fedora (mutable) | .deb... rpm/dnf | No native | High | Good | Medium | Simpler than atomic but loses rollback; less aligned with "reliable updates" |
| SteamOS 3.0 (Arch) | Image-based (Valve) | Yes | Excellent (gaming-only) | NVIDIA support only added in 3.8.10 beta (2026) | N/A (not a general OS) | Gaming Mode is excellent but desktop/refresh UX is secondary; not a general-purpose base |
| Bazzite (Fedora Atomic) | Image-based | Yes | Excellent | Preinstalled proprietary NVIDIA | Low (as user) | **This is essentially what MODULUS OS would be if we just rebranded.** We must differentiate via first-party services/UX, not by rebuilding the base. |
| Nobara (Fedora mutable) | Rolling on Fedora | Limited | Excellent | Preinstalled proprietary NVIDIA | Medium | Mutable; no Secure Boot support (must disable SB); smaller team |

### 2.2 Observations

- **Bazzite** is the closest existing product to MODULUS OS's gaming + desktop vision. It proves Fedora Atomic + KDE Plasma + Steam + Proton works well and ships NVIDIA drivers out of the box. It also shows the "custom image" (Universal Blue / bootc) workflow is viable for a small team.
- **Nobara** shows Fedora can be made gaming-ready, but its mutable base and lack of Secure Boot support are liabilities for a "secure by default" product.
- **SteamOS 3.0** shows Arch + immutable image + Gamescope + KDE Plasma is a viable gaming OS, but NVIDIA support only arrived in 2026 and it is not a general-purpose desktop.
- **Nobara explicitly does not support Secure Boot.** MODULUS OS should support Secure Boot (spec Part 9.5). This favors the Fedora Atomic + akmods + MOK path, which Bazzite already navigates.

### 2.3 Recommendation (pending validation)

**Recommended foundation: Fedora Atomic Desktop (Kinoite variant) built as a custom image via bootc/Universal Blue-style workflow.**

Rationale:
1. Atomic updates + rollback align with "reliable updates" (Part 17).
2. SELinux + signed images align with "security by default".
3. NVIDIA proprietary drivers are already packaged and shipped by Bazzite on this base (proven).
4. PipeWire, Wayland, KDE Plasma 6 available out of the box.
5. Container-first app model (Flatpak) aligns with "don't mutate base".
6. Lower maintenance burden than maintaining an Arch fork.

**Validation spike required (Phase 1, Task 0):** Build a Kinoite-based image, boot in VM + on one NVIDIA machine with Secure Boot ON, install NVIDIA drivers via akmods, verify Steam + a Proton game launches, verify rollback after a broken update. If this fails, fall back to mutable Fedora or evaluate Arch.

**Rejected for v1:** Arch-based (too much maintenance for a small team aiming at everyday users), Ubuntu mutable (weak rollback story), SteamOS (not general-purpose).

## 3. Desktop environment comparison

| Option | Maturity | Gaming alignment | Extensibility | Risk |
|---|---|---|---|---|
| KDE Plasma 6 + KWin (Wayland) | Very high | High (Bazzite/SteamOS use it) | High (QML, KCMs, look-and-feel packages) | Low |
| GNOME (Mutter) | Very high | Medium | Medium (extensions fragile) | Medium for gaming UX |
| COSMIC (System76) | Low-Medium (new) | Unknown | Medium | High (immature) |
| Custom shell from scratch | N/A | N/A | Total control | Very high (spec explicitly warns against unnecessary forks) |

**Recommendation:** KDE Plasma 6 + KWin as the foundation, customized via look-and-feel packages, QML, and KCMs — **not** a fork. This matches Bazzite/SteamOS precedent and avoids forking a large desktop project (Principle 3.1/5.2).

**Open question (VERIFY):** Whether deep Plasma customization can achieve the "premium Fluent" look without forking. Prototype a look-and-feel package in Phase 2 before committing.

## 4. Technology evaluation per subsystem

### 4.1 Core services language
- **Rust** for daemons (memory safety, performance, zbus for D-Bus, tokio async). Used by many modern Linux services.
- **C++/Qt** for desktop integration and QML plugins.
- **Python** only for installer scripts / tooling, not for services.

### 4.2 IPC
- **D-Bus** (system + session bus) with documented interfaces in `/usr/share/dbus-1/...` and a shared `modulus-common` crate defining types.
- **Polkit** for authorization; never call privileged code from the UI process.

### 4.3 Configuration
- TOML or JSON schemas, validated, versioned, documented. Single source of truth in a system service; UI reads/writes via D-Bus.

### 4.4 Gaming stack
- Steam + Proton (reuse; do not reimplement).
- **Gamescope** for fullscreen gaming compositor (reuse Valve's).
- **MangoHud** for performance overlay (reuse).
- Modulus Play = a Qt/QML launcher that *wraps* Steam and manages per-game configs + AdaptiveCore integration. It does NOT reimplement a store or Proton.

### 4.5 Security stack
- ClamAV for malware scanning (integrate; do not build an AV engine).
- nftables via firewalld (integrate; do not replace firewall).
- SELinux (Fedora default) for MAC.
- Flatpak sandboxing for apps.
- Secure Boot + LUKS2 + signed updates.

### 4.6 Wallpaper
- Start with static + video via a lightweight mpv-based renderer communicating with AdaptiveCore.
- Interactive wallpapers: restricted runtime (container/sandbox) with resource limits — deferred to Phase 6.

### 4.7 Software Center
- Adopt **Bazaar** (Flatpak store, used by Bazzite) initially with Modulus branding. Re-evaluate building own only if branding/UX gaps justify it.

### 4.8 Terminal
- Ship **Konsole** (KDE) with Modulus theme + profiles initially. GPU-accelerated rendering already available via Qt. Revisit custom terminal only if UX gaps.

### 4.9 Installer
- **Anaconda** (Fedora's) with custom branding. Risk: complexity. Alternative: Calamares. Decision deferred to Phase 1 spike; Anaconda is the safe default for an immutable Fedora image.

### 4.10 Boot splash
- **Plymouth** with a Modulus theme. Never delay boot for animation.

### 4.11 Audio
- **PipeWire** (Fedora default). No custom audio stack.

### 4.12 Hardware detection
- udev + /sys + libdrm + DMI. Expose via a Hardware Compatibility Service. Maintain a JSON hardware DB shipped with the OS (community-contributed).

## 5. What we will NOT build (scope control)

Per the spec's "upstream-first" principle and scope realism:

- No custom kernel.
- No custom compositor (reuse KWin).
- No custom AV engine (integrate ClamAV).
- No custom firewall (integrate nftables/firewalld).
- No custom package format (use rpm-ostree + Flatpak).
- No from-scratch desktop shell (customize Plasma).
- No store reimplementation initially (adopt Bazaar).
- No from-scratch terminal initially (Konsole).

First-party code is reserved for: AdaptiveCore, GPUCore, SecureCore (integration layer), WallpaperCore, Modulus Play, Update Manager (thin wrapper), Hardware Compatibility Service, Diagnostics Service, System Configuration Service, Control Center, design system, and branding.

## 6. Open questions requiring validation

1. Does akmods + MOK allow NVIDIA drivers on a Secure Boot Kinoite image with acceptable UX? (Spike)
2. Can Plasma 6 look-and-feel achieve the target premium aesthetic without forking? (Phase 2 prototype)
3. What is the real low-end hardware floor? (Benchmark in Phase 8; do not publish claims before)
4. Is Bazaar customizable enough for Modulus branding, or do we need our own store? (Phase 7)
5. Does Gamescope + MangoHud + AdaptiveCore coordinate cleanly, or do they fight over GPU? (Phase 4)

## 7. Sources

- Wikipedia: Bazzite (operating system) — https://en.wikipedia.org/wiki/Bazzite_(operating_system)
- Wikipedia: Nobara (operating system) — https://en.wikipedia.org/wiki/Nobara_(operating_system)
- Wikipedia: SteamOS — https://en.wikipedia.org/wiki/SteamOS
- Fedora Atomic Desktops documentation (referenced via Bazzite/Nobara/SteamOS articles)
- MODULUS OS master engineering specification (provided by user)

Note: Web search was unavailable during this research pass; findings are based on fetched reference pages and prior knowledge. Re-verify version numbers and feature claims before finalizing ADRs.