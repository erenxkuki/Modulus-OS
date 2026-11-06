# MODULUS OS — Update & Rollback Architecture

## Base OS (image-based)

- Built as a signed container image (bootc) from a documented Containerfile.
- Deployed via rpm-ostree: staging → reboot → new deployment; previous deployment retained.
- Rollback: `rpm-ostree rollback` (or boot menu entry) restores previous deployment.
- Updates are atomic: either fully applied or not; no partial system state.
- Interrupted updates (power loss mid-staging) must leave the current deployment bootable.

## Applications (Flatpak)

- Per-user and system-wide Flatpak installs.
- Updates via Flatpak; failures are isolated to the app, never the base OS.
- Source attribution shown in Software Center.

## Update Manager (first-party, thin wrapper)

- Checks for base + Flatpak updates.
- Notifies user; user controls restart timing.
- Shows update history and failures.
- Triggers rollback on user request via Polkit-gated D-Bus method.

## Recovery

- Recovery environment in boot menu (previous deployment + rescue image).
- Recovery utility (app) for diagnostics, rollback, and reset-to-factory (with explicit confirmation).
- All destructive ops require explicit user confirmation.

## Testing requirements

- Interrupted update (kill mid-download, power loss) → system still boots.
- Broken update (bad image) → rollback restores working system.
- Rollback after 3+ updates → still works.
- Offline update (cached image) works.