# MODULUS OS — Security Policy

## Reporting vulnerabilities

Report security issues privately to the maintainers. Do not open public issues for undisclosed vulnerabilities. (Contact details to be added before release.)

## Security principles

- Security by default (Part 9).
- No privileged operations from untrusted desktop apps.
- Authenticated IPC (D-Bus) + Polkit authorization.
- Least privilege; auditable system services.
- Signed updates; Secure Boot; LUKS2; TPM 2.0 where available.
- No telemetry without explicit opt-in and documentation.

## Trust boundaries

See `docs/architecture/privilege-boundaries.md`.

## Supported versions

Pre-release: no stable versions yet. Security fixes apply to the latest image only.