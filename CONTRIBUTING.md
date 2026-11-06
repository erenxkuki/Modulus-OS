# MODULUS OS — Contributing

## Before you start

1. Read the master specification and `README.md`.
2. Read `docs/architecture/system-architecture.md` and relevant ADRs.
3. Check `status/project-status.md` for current phase and blockers.

## Development rules

- Research existing solutions before inventing.
- Never fake functionality; never ship no-op UI.
- Never execute privileged ops from UI; use D-Bus + Polkit.
- Never disable security for performance.
- Every feature needs tests; a feature is not done because it compiles.
- Performance claims need benchmarks.
- Update docs and status when you change scope.

## Code standards

- Rust for services (rustfmt + clippy clean).
- C++/Qt for desktop integration.
- Documented D-Bus interfaces; versioned schemas.
- Unit + integration tests required.

## Pull requests

- Small, focused changes.
- Reference the phase/task being addressed.
- Include tests and docs updates.

## Quality gates

A phase is not complete until its acceptance criteria pass. See `docs/...` and `ROADMAP.md`.