# MODULUS OS — Testing Strategy

Per Part 23. Every feature needs tests; a feature is not done because it compiles.

## Test levels

### Unit tests
- Individual functions and service behavior.
- Rust: `cargo test` per crate.
- C++/Qt: Qt Test.
- Run in CI on every PR.

### Integration tests
- Service-to-service communication via D-Bus.
- Use a test harness that spins up services in a sandboxed environment.
- Verify IPC contracts, Polkit authorization, config change propagation.

### Security tests
- Authorization: verify Polkit actions gate privileged methods.
- Sandboxing: verify Flatpak permissions enforced.
- Input handling: fuzz D-Bus methods and config inputs.
- Privilege boundaries: verify UI process cannot escalate.
- Run in a dedicated security CI job.

### Performance tests
- Boot time, desktop responsiveness, memory, CPU overhead, GPU utilization, frame-time consistency, app startup, battery.
- Compare against a clean Fedora Kinoite install (baseline).
- Run on representative VM configurations; track regressions.

### Hardware tests
- Real hardware: NVIDIA, AMD, Intel GPUs; hybrid laptops; low-memory machines; older CPUs; various storage/display configs.
- Requires a hardware lab (R-10). Community beta program can extend coverage.

### Recovery tests
- Interrupted updates (kill mid-staging, power loss).
- Broken update (bad image) → rollback.
- Rollback after N updates.
- Offline update (cached image).

### UI tests
- User workflows (install app, connect Wi-Fi, change wallpaper, launch game).
- Error handling and empty states.
- Accessibility: keyboard navigation, screen reader, reduced motion.
- Automated where feasible (e.g., Dogtail/AT-SPI); manual otherwise.

## Coverage expectations

- New code: unit tests required for merge.
- Services: integration tests for public interfaces.
- Security-relevant code: security tests + review.
- Performance-sensitive code: benchmark before/after.

## CI pipeline

1. Lint + format (rustfmt, clippy, clang-format).
2. Unit tests.
3. Integration tests (in container with D-Bus).
4. Security tests.
5. Build image (when build host available).
6. Performance benchmarks (nightly, on dedicated runner).

## Definition of done (per component)

- Working implementation.
- Documented architecture.
- Unit tests.
- Integration tests where relevant.
- Error handling + logging.
- Security review where relevant.
- Performance measurements.
- User-facing docs.