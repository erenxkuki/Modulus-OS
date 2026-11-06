# MODULUS OS

**Tagline:** One system. Every possibility.
**Type:** Linux-based desktop operating system
**Status:** Phase 0 — Research & Architecture (no code yet)

## What this is

MODULUS OS is a modular, Linux-based desktop operating system intended to combine:

- Windows-level usability for everyday users
- Linux-level flexibility for power users and developers
- First-class gaming support
- A premium, consistent desktop experience

It is **not** a re-skinned distribution and **not** a from-scratch kernel. It is built on top of established upstream Linux technologies, with first-party services and applications layered on top.

## Read first

- Master specification: see the project's master engineering prompt (the source of truth for scope and rules).
- Phase 0 research report: [`research/research-report.md`](research/research-report.md)
- System architecture: [`docs/architecture/system-architecture.md`](docs/architecture/system-architecture.md)
- Architecture decisions: [`docs/decisions/`](docs/decisions/)
- Risk register: [`risks/risk-register.md`](risks/risk-register.md)
- Phase 1 plan: [`plans/phase1-implementation-plan.md`](plans/phase1-implementation-plan.md)
- Project status: [`status/project-status.md`](status/project-status.md)

## Engineering rules (non-negotiable)

1. Research before implementing. Architecture before code.
2. Upstream-first: reuse mature Linux projects; do not recreate mature infrastructure.
3. No custom kernel without a demonstrated requirement.
4. No fake functionality, no decorative no-op buttons, no hardcoded hardware data.
5. Security is never traded for performance or visuals.
6. Every privileged operation goes through authenticated IPC + Polkit, never from the desktop app directly.
7. Performance claims require benchmarks.
8. Phase acceptance criteria must pass before a phase is marked complete.

## Current phase

**Phase 0 — Research and feasibility.** No implementation has started. The immediate deliverables are the research report, architecture, technology selection, risk register and Phase 1 task breakdown, all of which live in this repository.

## Repository layout

```
modulus-os/
├── README.md
├── ROADMAP.md
├── SECURITY.md
├── CONTRIBUTING.md
├── research/          # Phase 0 research
├── docs/
│   ├── architecture/  # Architecture specifications
│   └── decisions/     # Architecture Decision Records (ADRs)
├── risks/             # Risk register
├── plans/             # Implementation plans
└── status/            # Project status tracking
```

Subsystems (desktop/, services/, applications/, installer/, etc.) will be added only when their phase begins, to avoid placeholder modules.

## Status of decisions

All technology choices are currently **"recommended, pending validation"**. None are final until a small validation spike confirms them on real hardware (see Phase 1 plan, Task 0.x). See ADR-0001 for the foundation decision.