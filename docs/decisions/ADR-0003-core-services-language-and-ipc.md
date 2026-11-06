# ADR-0003: Core services language and IPC

**Status:** Accepted
**Date:** 2026-11-06

## Decision

- **Language for system services:** Rust (memory safety, performance, strong async/D-Bus ecosystem via `zbus`).
- **Desktop integration / QML plugins:** C++/Qt 6.
- **IPC:** D-Bus (system + session bus), with documented interfaces.
- **Authorization:** Polkit actions with defined levels (no, user, admin).
- **Configuration:** A single System Configuration Service owning canonical state; schemas versioned and validated (TOML/JSON).
- **Scripting/tooling:** Python only for installer helpers and build scripts — never for runtime services.

## Rationale

1. Rust's memory safety reduces security bugs in privileged daemons (Part 9).
2. D-Bus/Polkit are the standard Linux IPC/auth stack; reusing them avoids custom security-critical code.
3. A single config service prevents duplicated configuration logic (Part 13).

## Consequences

- Team needs Rust expertise; hiring/training cost.
- All privileged operations must be reachable only via D-Bus + Polkit; direct calls from UI are forbidden (enforced in review).
- Interface definitions live in a shared `modulus-common` crate and are versioned.