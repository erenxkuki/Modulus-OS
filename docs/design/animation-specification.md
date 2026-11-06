# MODULUS OS — Animation Specification

Per Part 5.3. Consistent motion across all applications.

## Principles

- Animations communicate state changes, never block interaction.
- Reduced-motion mode disables non-essential animation (instant transitions).
- Adaptive quality: simplify or disable on low-end GPUs / battery saver.
- Target 60 FPS on supported hardware; higher refresh where appropriate. Never guarantee fixed FPS.

## Durations (from design system)

| Token | Value | Use |
|---|---|---|
| `motion.fast` | 120ms | Hover, focus, toggle, micro-interactions |
| `motion.normal` | 200ms | Window open/close, dialog appear, nav transitions |
| `motion.slow` | 320ms | Desktop switch, page transitions, large layout changes |

## Easing curves

- `standard`: cubic-bezier(0.4, 0, 0.2, 1) — default for most transitions.
- `decelerate`: cubic-bezier(0, 0, 0.2, 1) — elements entering.
- `accelerate`: cubic-bezier(0.4, 0, 1, 1) — elements exiting.
- `emphasized`: cubic-bezier(0.2, 0, 0, 1) — hero transitions (sparingly).

## Animation catalog

### Window lifecycle
- Open: scale 0.96→1.0 + opacity 0→1, `motion.normal`, `decelerate`.
- Close: scale 1.0→0.96 + opacity 1→0, `motion.fast`, `accelerate`.
- Minimize: scale to taskbar icon position + opacity fade, `motion.normal`.
- Maximize/restore: bounds animate to target, `motion.normal`.
- Snap: quick slide to edge, `motion.fast`.

### Application launch
- Icon → window: shared-element transition where supported; fallback fade+scale.

### Settings / Control Center
- Page transitions: slide + fade, `motion.normal`.
- Toggle switches: 120ms spring.

### Taskbar
- Hover preview: fade + scale, `motion.fast`.
- Icon bounce on launch: subtle, once.

### Notifications
- Slide in from top-right + fade, `motion.normal`, `decelerate`.
- Dismiss: slide out + fade, `motion.fast`, `accelerate`.

### Quick settings
- Panel slide + blur backdrop, `motion.normal`.

### Login
- Fade + subtle scale on login, `motion.slow`.

### Desktop switching
- Slide + parallax, `motion.slow`.

### Dialogs
- Scale 0.95→1.0 + fade, `motion.normal`, `decelerate`.

## Adaptive quality

- Low-end profile: disable blur, shadows, transparency; reduce animation to fade-only; shorten durations by 30%.
- Gaming mode: disable desktop animations entirely (instant) to reduce overhead.
- Battery saver: reduce animation quality (fade-only, no blur).
- Reduced-motion: all transitions instant (0ms) except essential feedback.

## Implementation

- Use KWin's effect system for window-level animations.
- Use QML `Behavior` / `Transition` for in-app motion.
- Centralize easing/duration tokens in the design system (QML singleton).
- Never use blocking animations; all must be cancellable.