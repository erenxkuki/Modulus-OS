# ADR-0002: Desktop environment and UI toolkit

**Status:** Recommended (pending Phase 2 prototype)
**Date:** 2026-11-06

## Context

MODULUS OS needs a desktop foundation that is mature, accessible, multi-monitor capable, gaming-friendly, and extensible for a premium custom look. The spec warns against forking large desktop projects.

## Decision

**Use KDE Plasma 6 + KWin (Wayland) as the desktop foundation, customized via look-and-feel packages, QML and KCMs — not a fork. UI toolkit: Qt 6 / QML.**

## Rationale

1. Plasma 6 is mature, accessible, and has strong multi-monitor support.
2. Bazzite and SteamOS both ship Plasma — gaming ecosystem alignment and proven drivers.
3. High extensibility via QML, look-and-feel packages, and KCMs allows a premium custom identity without forking.
4. Wayland is the modern default; KWin has good gaming (Gamescope) integration.
5. Qt 6/QML matches the spec's candidate stack.

## Consequences

- We must validate that the target "premium Fluent" aesthetic is achievable via look-and-feel packages without forking (Phase 2 prototype). If not, we may need a heavier custom shell — which the spec discourages and which would be a major scope increase.
- We inherit Plasma's release cadence and UX conventions; some UI will look "Plasma" unless carefully themed.
- Wayland-only means some X11-only tools won't work; acceptable for a modern OS.

## Alternatives considered

- **GNOME**: mature but extensions are fragile and gaming UX is weaker. Rejected for v1.
- **COSMIC**: promising but immature; defer evaluation to a later phase.
- **Custom shell from scratch**: rejected (spec Principle 3.1/5.2).