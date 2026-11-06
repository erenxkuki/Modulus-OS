# MODULUS OS — Recovery Procedures

## Recovery entry points

1. **Boot menu** — previous deployment (rollback) and recovery environment.
2. **Recovery utility** (app) — diagnostics, rollback, reset to factory.
3. **Terminal** — `rpm-ostree rollback`, `rpm-ostree status`.

## Scenarios

### Failed update (system won't boot)
1. Boot menu → select previous deployment.
2. System boots into last known-good state.
3. Update Manager shows the failed update and offers retry or rollback.

### Interrupted update (power loss mid-staging)
1. On next boot, rpm-ostree detects incomplete staging and discards it.
2. System boots normally into current deployment.

### Broken driver (e.g., NVIDIA)
1. Boot menu → previous deployment (if driver was part of an update).
2. Or: Recovery utility → "Reinstall default driver" (Polkit-gated).
3. Never silently replace a working driver.

### User wants factory reset
1. Recovery utility → "Reset to factory defaults."
2. Requires explicit confirmation + admin auth.
3. Wipes user data and config; reinstalls base image.
4. Preserves nothing unless user exports first.

### Data recovery
1. Recovery environment provides a shell and file manager.
2. User can mount LUKS2 volume with passphrase.
3. No automatic data upload.

## Safety rules

- All destructive operations require explicit confirmation and Polkit authorization.
- Recovery environment is read-only except for user data partitions.
- Rollback is always available for at least the previous deployment.
- Never claim recovery succeeded without verification.