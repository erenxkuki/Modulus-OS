# MODULUS OS — Risk Register

Scale: Probability/Impact = Low/Medium/High. Updated each phase.

| ID | Risk | Prob | Impact | Mitigation | Testing |
|---|---|---|---|---|---|
| R-01 | NVIDIA + Secure Boot + akmods UX is painful/broken | Medium | High | Validate in Phase 1 spike; document MOK flow; consider shipping pre-signed modules if feasible | Spike on real NVIDIA hardware with SB on |
| R-02 | Fedora Atomic base blocks a needed package/hardware fix | Medium | Medium | Keep a documented exception process (kernel module overlay); evaluate Ubuntu if blockers persist | Phase 1 install on 3 hardware configs |
| R-03 | Scope creep: 9 subsystems never ship | High | High | Strict phase gates; ship bootable image (Phase 1) first; reject features without acceptance criteria | Phase reviews |
| R-04 | Plasma customization cannot reach "premium" target without forking | Medium | High | Phase 2 prototype look-and-feel; if fails, reassess (possibly heavier shell) | UI prototype review |
| R-05 | AdaptiveCore restores state incorrectly after game crash | Medium | High | Watchdog supervisor; explicit crash tests; restoration is idempotent | Crash-injection tests |
| R-06 | Performance claims unverified / regressions | Medium | Medium | Benchmarks per Principle 3.5; CI performance checks; compare to clean Fedora install | Automated + manual benchmarks |
| R-07 | Security Center shows false "protected" | Low | High | Service health checks gate status; accuracy tests | Security tests |
| R-08 | Low-end hardware unusable due to effects | Medium | Medium | Adaptive visual quality tiers; test on low-end VMs/old machines | Phase 8 hardware tests |
| R-09 | Update/rollback breaks after interrupted update | Low | High | Atomic staging; recovery tests; never assume rollback semantics | Recovery test suite |
| R-10 | No hardware testing lab (single dev machine) | High | High | User recommendation: acquire NVIDIA/AMD/Intel test machines + VMs; community beta | Hardware test matrix |
| R-11 | Custom services become unmaintainable (Rust skill gap) | Medium | Medium | Keep services small; documented interfaces; upstream fixes preferred | Code review, tests |
| R-12 | Trademark/domain for "MODULUS" unresolved | Medium | Low | Keep working name; check before release (user note) | Legal review before release |

Top 10 technical risks: R-01, R-02, R-03, R-04, R-05, R-06, R-08, R-09, R-10, R-11.