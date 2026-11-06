# MODULUS OS — Design System

Source of truth for visual tokens. All applications must consume these tokens; no ad-hoc values.

## 1. Color tokens

### Brand
- `color.brand.primary` — Modulus accent (default blue-violet). Used for primary actions, focus rings, active states.
- `color.brand.secondary` — Complementary accent for highlights.

### Semantic
- `color.bg.base` — Window/page background.
- `color.bg.surface` — Card/panel background.
- `color.bg.elevated` — Dialog/popover background.
- `color.bg.overlay` — Scrim behind modals.
- `color.fg.primary` — Primary text.
- `color.fg.secondary` — Secondary/muted text.
- `color.fg.disabled` — Disabled text.
- `color.border.default` — Default borders.
- `color.border.focus` — Focus ring (uses brand primary).
- `color.status.success`, `.warning`, `.error`, `.info`.

### Light / dark
Each semantic token resolves per theme. Dark mode is not "inverted light"; it is a separately tuned palette. Both must pass WCAG AA contrast (4.5:1 body text).

## 2. Typography

- Font family UI: `Inter` (or system sans fallback).
- Font family mono: `JetBrains Mono` (terminal, code).
- Scale (rem): 0.75, 0.875, 1.0, 1.125, 1.25, 1.5, 1.875, 2.25.
- Weights: 400 (body), 500 (labels), 600 (headings), 700 (display).
- Line heights: 1.25 (tight), 1.5 (body), 1.75 (relaxed).

## 3. Spacing

4px base grid. Tokens: 0, 2, 4, 6, 8, 12, 16, 20, 24, 32, 40, 48, 64 (px).

## 4. Border radius

- `radius.none` 0
- `radius.sm` 4px (inputs, small buttons)
- `radius.md` 8px (cards, dialogs)
- `radius.lg` 12px (panels)
- `radius.xl` 16px (windows, large surfaces)
- `radius.full` 9999px (pills, avatars)

## 5. Shadows / elevation

- `elevation.0` none
- `elevation.1` subtle (cards at rest)
- `elevation.2` medium (hover/raised)
- `elevation.3` high (dialogs, popovers)
- `elevation.4` overlay (modals, menus)

Shadows are disabled in reduced-motion / low-end profiles.

## 6. Motion

- Durations: `motion.fast` 120ms, `motion.normal` 200ms, `motion.slow` 320ms.
- Easing: `motion.ease.standard` cubic-bezier(0.4,0,0.2,1); `motion.ease.decelerate` (0,0,0.2,1); `motion.ease.accelerate` (0.4,0,1,1).
- All animations must respect reduced-motion (instant transitions).
- Adaptive quality: blur/transparency/shadows disabled on low-end profile; animations simplified.

## 7. Iconography

- Single icon set (Lucide or custom Modulus set) at 16/20/24px.
- Stroke width consistent (1.5px default).
- Icons must have accessible labels.

## 8. Component states

Every interactive component defines: default, hover, focus, active, disabled, loading, error. Focus ring always visible (keyboard nav).

## 9. Accessibility

- Minimum touch target 44x44px.
- Color not sole conveyor of information.
- Reduced-motion mode disables non-essential animation.
- High-contrast theme available.