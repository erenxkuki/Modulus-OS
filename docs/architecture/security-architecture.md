# MODULUS OS — Security Architecture

## Modules (integration, not from-scratch)

- Malware scanning: ClamAV (manual + scheduled + on-demand + download + removable media).
- Real-time file monitoring: ClamAV on-access (where feasible) + suspicious behavior heuristics.
- File integrity monitoring: AIDE or rpm-ostree's built-in verification.
- Quarantine: isolated directory, restore only with confirmation.
- Firewall: nftables via firewalld, managed through SecureCore UI.
- Application permissions: Flatpak sandbox permissions + Polkit.
- Security updates: signed, automatic notification, user-controlled apply.
- USB device security: prompt on new device, block autorun.
- Secure Boot + TPM 2.0 + LUKS2 + signed updates.

## Trust boundaries

- Untrusted content never runs privileged.
- Scanning engine runs as a dedicated user with read access only where needed.
- Quarantine directory not executable.

## Transparency rules

- Security Center shows accurate status; if a protection service is down, show "unavailable", not "protected".
- Signature scanning is not advertised as behavioral protection.
- Detection limitations documented.

## Key management

- Secure Boot keys managed via MOK for third-party modules (NVIDIA akmods).
- Update signing keys shipped in the image; rotation documented.