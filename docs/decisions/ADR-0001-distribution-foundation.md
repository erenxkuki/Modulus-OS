# ADR-0001: Distribution foundation

**Status:** Recommended (pending validation spike)
**Date:** 2026-11-06
**Deciders:** MODULUS OS engineering

## Context

MODULUS OS needs a Linux foundation that supports: reliable updates with rollback, strong hardware support (NVIDIA/AMD/Intel), gaming compatibility, package availability, security updates, and low maintenance burden for a small team. The master spec requires comparing Fedora Atomic, Arch-based, and Ubuntu-based approaches and documenting the decision.

## Decision

**Use Fedora Atomic Desktop (Kinoite variant) as the base, built as a custom image via a bootc/Universal-Blue-style workflow.**

## Comparison

| Criterion | Fedora Atomic (Kinoite) | Arch Linux | Ubuntu LTS |
|---|---|---|---|
| Update reliability | High (atomic, image-based) | Medium (rolling, per-package) | Medium-High (point releases) |
| Rollback | Built-in (previous deployment) | Manual (snapshots) | Manual (Timeshift) |
| Hardware support | Good | Excellent (latest kernel) | Good |
| NVIDIA compatibility | Good (akmods, proven by Bazzite) | Good | Good |
| AMD/Intel | Good | Good | Good |
| Gaming compatibility | High (Proton, Steam) | High | Medium-High |
| Package availability | Good (rpm + Flatpak + brew) | Excellent (AUR) | Excellent (.deb) |
| Maintenance burden | Medium | High | Low |
| Security update speed | Fast | Fast | Moderate |
| Secure Boot support | Yes (with MOK for akmods) | Yes | Yes |

## Rationale

1. Atomic updates + rollback directly serve Part 17 (reliable updates/recovery).
2. SELinux + signed images serve Part 9 (security by default).
3. Bazzite proves this exact base works for gaming with NVIDIA drivers preinstalled.
4. Lower maintenance than an Arch fork, while still giving users a rolling-ish experience via updates.
5. PipeWire, Wayland, Plasma 6, and Flatpak are first-class on Fedora.

## Consequences

- We inherit Fedora's release cadence (~6 months) and rpm-ostree/bootc semantics.
- NVIDIA + Secure Boot requires akmods + MOK enrollment; UX must be documented and tested (risk R-01).
- Package layering (`rpm-ostree install`) is slow and not for everyday app installs; apps go through Flatpak.
- We must maintain a custom image build pipeline (reproducible builds — user's recommendation).
- We do not control kernel timing; if a hardware fix needs a newer kernel, we wait for Fedora or use a kernel module overlay (documented exception).

## Alternatives considered

- **Arch Linux**: best driver freshness, but rolling breakage risk and no native rollback make it unsuitable for everyday users. Rejected for v1.
- **Ubuntu LTS**: largest ecosystem, but mutable base weakens rollback story. Rejected for v1; reconsider if Fedora Atomic blockers emerge.
- **SteamOS 3.0**: excellent gaming UX but not general-purpose; NVIDIA support only recent. Rejected as a base.
- **Nobara**: mutable Fedora with gaming tweaks; no Secure Boot. Rejected (conflicts with security goals).

## Validation spike (must pass before finalizing)

1. Build a Kinoite-based image.
2. Boot in VM and on one NVIDIA machine with Secure Boot ON.
3. Install NVIDIA drivers via akmods; verify MOK enrollment UX.
4. Launch Steam and one Proton game.
5. Perform a broken update; verify rollback restores working system.

If any step fails, revisit this ADR. Do not mark Phase 1 complete until the spike passes.

## Related

- `docs/architecture/update-rollback-architecture.md`
- `risks/risk-register.md` (R-01, R-02)