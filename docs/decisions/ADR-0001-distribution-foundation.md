# ADR-0001: Distribution foundation

**Status:** Partially validated (base image confirmed; build/boot/rollback not yet tested)
**Date:** 2026-11-06 (updated 2026-11-06 with image inspection results)
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

## Partial validation (2026-11-06, via skopeo on RemoteForge VPS)

The base image `quay.io/fedora-ostree-desktops/kinoite:41` was pulled and inspected without a build host:

- ✅ Image exists and is a valid OCI v2 manifest (65 layers).
- ✅ `containers.bootc = 1` — bootable container.
- ✅ `ostree.bootable = true` — ostree-bootable image.
- ✅ `ostree.commit = 1bd9ee3f...` — ostree commit present.
- ✅ `ostree.linux = 6.17.9-100.fc41.x86_64` — Fedora 41 kernel.
- ✅ `rpmostree.inputhash` present — built with rpm-ostree.
- ✅ Layer search confirmed `rpm-ostree`, `plasmashell`, and `kwin` binaries present in the image.
- ✅ Architecture: amd64. Multi-arch support (x86_64 + aarch64 tags available).
- ✅ Created: 2025-12-02.

**Conclusion:** The base image is confirmed to be a genuine Fedora Kinoite (KDE Plasma) atomic desktop with rpm-ostree, ostree bootability, and a recent kernel. This validates the core claim of ADR-0001.

**Still unvalidated (requires a real build host with KVM):**
- Building the MODULUS image (podman with working namespaces — unavailable in the RemoteForge container).
- Booting in a VM.
- NVIDIA + Secure Boot + MOK enrollment (requires physical NVIDIA hardware).
- Interrupted update recovery.
- Rollback after a broken update.

## Validation spike (remaining steps)

1. ~~Build a Kinoite-based image~~ — BLOCKED (no podman with namespaces in available environment).
2. ~~Boot in VM~~ — BLOCKED (no QEMU/KVM).
3. ~~Boot on NVIDIA machine, Secure Boot ON~~ — requires physical hardware.
4. ~~Test interrupted update~~ — requires bootable image.
5. ~~Test rollback~~ — requires bootable image.

## Related

- `docs/architecture/update-rollback-architecture.md`
- `risks/risk-register.md` (R-01, R-02)
- `docs/development/validation-spike-plan.md`