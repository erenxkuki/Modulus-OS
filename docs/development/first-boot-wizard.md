# MODULUS OS — First-Boot Wizard

Runs after installation, before the desktop loads. Graphical, keyboard-navigable, skippable.

## Steps

1. **Welcome** — brand intro, "One system. Every possibility."
2. **Language & keyboard** — select locale and keyboard layout.
3. **Network** — connect to Wi-Fi/Ethernet (can skip; retry later).
4. **User account** — already created by installer; confirm/adjust display name and avatar.
5. **Theme** — choose light/dark/auto; pick accent color.
6. **Performance profile** — detect hardware and suggest a profile; user can override.
   - Show detected GPU and recommended driver status.
   - If NVIDIA + Secure Boot: explain MOK enrollment if needed.
7. **Privacy** — telemetry off by default; explain what diagnostics collect; opt-in.
8. **Updates** — check for updates; offer to apply now.
9. **Finish** — summary; "Start using MODULUS OS."

## Behavior

- Skippable at any step (with confirmation).
- If skipped, defaults are applied and settings remain editable in Control Center.
- Low-end hardware: wizard uses reduced effects.
- No terminal required.
- All choices write through System Configuration Service.