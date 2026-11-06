# MODULUS OS — Low-End Hardware Profiles

Per Part 14. Profiles are based on detected capabilities + user preference, not marketing labels.

## Profile classes

### Lightweight
- Older CPUs (pre-2015, 2-4 cores).
- Integrated graphics (no Vulkan 1.3, or < 1GB VRAM).
- ≤ 4 GB RAM.
- HDD or slow storage.

Adaptive behavior:
- Disable blur, transparency, shadows.
- Disable desktop animations (instant transitions).
- Static wallpaper only (no video/live).
- Limit background services (no wallpaper engine, no real-time scan daemon unless requested).
- Reduced widget update frequency.
- Memory-pressure awareness: keep cache small, avoid preloading.

### Balanced
- Entry-level modern systems.
- Integrated or entry-level dedicated GPU with Vulkan 1.3.
- 4–8 GB RAM.
- SSD.

Adaptive behavior:
- Moderate blur/transparency.
- Standard animations at 60 FPS.
- Static + simple animated wallpapers.
- Normal background services.

### Performance
- Modern gaming desktops.
- Dedicated GPU (≥ 4 GB VRAM).
- ≥ 16 GB RAM.
- NVMe SSD.
- High-refresh display.

Adaptive behavior:
- Full visual effects.
- Animations up to display refresh rate.
- Live/interactive wallpapers allowed.
- All background services enabled.

## Detection

Hardware Compatibility Service detects:
- CPU cores, generation, frequency.
- GPU vendor, model, VRAM, Vulkan version.
- RAM total.
- Storage type (HDD/SSD/NVMe) and speed.
- Display refresh rate.

Profile is suggested on first boot; user can override in Control Center.

## Graceful degradation

- If a feature can't run at the selected quality, degrade silently (e.g., skip blur) rather than crash.
- Never aggressively kill user processes under memory pressure; warn and offer to close apps.
- Low-end profile must still be visually consistent (same design language, fewer effects).