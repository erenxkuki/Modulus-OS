# ADR-0004: Update and packaging model

**Status:** Recommended
**Date:** 2026-11-06

## Decision

- **Base OS updates:** image-based via rpm-ostree/bootc, signed, atomic, with rollback.
- **Applications:** Flatpak (Flathub + Modulus repo), shown with source attribution.
- **Developer tools:** optional Homebrew (deferred to Phase 7).
- **No custom package format.** No mutation of the base image for app installs.

## Rationale

1. Atomic + rollback serves Part 17 and matches user's "compatibility-first release policy".
2. Flatpak gives sandboxing + permissions UI (Part 9.4, Part 11).
3. Avoids reinventing packaging (Principle 3.1).

## Consequences

- Update Manager is a thin wrapper, not a new package manager.
- Interrupted updates must be tested (recovery tests).
- Users cannot `dnf install` system packages casually; they use Flatpak or layering (documented).