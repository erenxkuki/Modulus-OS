# MODULUS OS — Privilege Boundaries

## Trust levels

1. **Untrusted content**: wallpapers (interactive), downloaded files, third-party apps.
2. **User applications**: run as the user, sandboxed where possible (Flatpak).
3. **Desktop shell / UI**: runs as user; must never hold privileges.
4. **System services**: run as dedicated system users; privileged only where required.
5. **Root / kernel**: minimal surface; accessed only via systemd/Polkit-gated services.

## Forbidden patterns

- UI process directly executing privileged commands (sudo, pkexec without Polkit action).
- Storing or using long-lived root credentials in user space.
- Disabling SELinux/AppArmor for performance.
- Silent driver replacement.
- Executing untrusted wallpaper/app content with system privileges.

## Required patterns

- All privileged ops exposed as D-Bus methods with Polkit actions.
- Least privilege: services drop capabilities; use dedicated users.
- Audit log for every privileged action (who, when, what, result).
- Sandboxing for untrusted content (containers, seccomp, resource limits).
- Secure Boot + signed updates + LUKS2 for system integrity.

## Audit

- Privileged actions logged to journald with structured fields and a correlation ID.
- Diagnostics Service can export an audit report.