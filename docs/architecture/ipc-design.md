# MODULUS OS — IPC Design

## Transport

D-Bus. System bus for privileged services; session bus for per-user desktop services where appropriate. Prefer system bus for services that must outlive the session.

## Bus names

- Services: `org.modulus.<ServiceName>` (e.g. `org.modulus.AdaptiveCore`)
- Interfaces: `org.modulus.<ServiceName>.<Interface>`
- Objects: `/org/modulus/<ServiceName>/<instance>`

## Interface conventions

- Every service exposes at least:
  - `org.freedesktop.DBus.Introspectable`
  - `org.modulus.<Service>.Status` (health, version)
- Methods are verb-first: `GetProfile`, `SetProfile`, `ApplyGameProfile`.
- State changes emit signals: `ProfileChanged(profile)`, `GameStarted(pid, gameId)`.
- Long operations return immediately and report progress via signals; never block the bus.

## Authorization

- Every mutating method is gated by a Polkit action: `org.modulus.<service>.<action>`.
- Actions define required authorization: `no` (anyone), `yes` (user), `auth_admin` (admin).
- Read-only methods may be `no`; writes are at least `auth_self`/`auth_admin`.

## Versioning

- Interfaces carry a version property. Breaking changes require a new interface name (`...V2`) with a deprecation window; old interface remains for one release.

## Error handling

- Methods return D-Bus errors with stable error names (`org.modulus.Error.NotFound`, `...PermissionDenied`, `...InvalidArgument`).
- Services log failures with correlation IDs.

## Configuration changes

- UI calls System Configuration Service; service validates schema, persists, and emits `ConfigChanged(key)`. Other services subscribe and react. No service reads config files directly.