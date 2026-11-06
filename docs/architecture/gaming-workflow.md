# MODULUS OS — Gaming Workflow

## Game detection & registration

- Steam games discovered via Steam's local config/library.
- Native Linux games registered manually or via desktop entries.
- Heroic/Lutris games imported via their configs (read-only integration; respect their auth).
- Per-game config stored in System Configuration Service (GPU, profile, env vars, Proton version).

## Launch sequence (Modulus Play → Play)

1. Verify installation exists.
2. Resolve launch config (runtime, Proton version, env).
3. Check GPU selection (GPUCore).
4. Apply AdaptiveCore gaming profile.
5. Reduce/pause desktop effects (WallpaperCore, animation quality).
6. Start resource + performance monitoring.
7. Launch game (via Steam/Proton/Gamescope as appropriate).
8. Track session (playtime, metrics).

## Exit sequence (normal or abnormal)

1. Detect process termination (including crash/kill).
2. Restore previous AdaptiveCore profile.
3. Restore desktop effects & wallpaper rendering.
4. Stop game-specific monitoring.
5. Record session summary (playtime, avg FPS, crashes).

**Critical:** Restoration must occur even after abnormal termination. Use a watchdog/supervisor in AdaptiveCore that detects game process death and restores state. Test crash scenarios explicitly.

## Performance overlay

- Reuse MangoHud (don't rebuild).
- Display: FPS, frame time, CPU/GPU util, RAM, VRAM, temps (where sensors exist), power.
- Clearly distinguish unavailable sensors from zero values.

## Gaming Mode UI

- Optional controller-friendly fullscreen interface (like Steam Big Picture).
- Never forced; user opts in.