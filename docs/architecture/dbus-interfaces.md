# MODULUS OS — D-Bus Interface Specifications

Canonical interface definitions. All services implement these. Versioned; breaking changes require a new interface name (`...V2`) with a deprecation window.

## Common

Every service exposes:
- `org.freedesktop.DBus.Introspectable`
- `org.modulus.Service.Status` → `{ version: string, healthy: bool, lastError: string }`

Error names: `org.modulus.Error.NotFound`, `.PermissionDenied`, `.InvalidArgument`, `.Unavailable`, `.Internal`.

## org.modulus.SystemConfig

Path: `/org/modulus/SystemConfig`
Bus: system

Methods:
- `Get(key: string) -> variant`
- `Set(key: string, value: variant) -> void` (Polkit: `org.modulus.systemconfig.set`)
- `GetSchema(key: string) -> string` (JSON schema)
- `ListKeys(prefix: string) -> []string`
- `Reset(key: string) -> void`

Signals:
- `ConfigChanged(key: string)`

## org.modulus.AdaptiveCore

Path: `/org/modulus/AdaptiveCore`
Bus: system

Methods:
- `GetProfile() -> string` (Daily|Gaming|Performance|Silent)
- `SetProfile(profile: string) -> void` (Polkit: `org.modulus.adaptivecore.setprofile`)
- `GetAutoMode() -> bool`
- `SetAutoMode(enabled: bool) -> void`
- `RegisterGame(gameId: string, config: dict) -> void`
- `GetGameConfig(gameId: string) -> dict`
- `GetMetrics() -> dict` (cpu, mem, gpu, temp, etc.)

Signals:
- `ProfileChanged(profile: string)`
- `GameStarted(pid: uint32, gameId: string)`
- `GameStopped(pid: uint32, gameId: string, summary: dict)`
- `ResourcePressure(level: string)` (low|medium|high)

## org.modulus.GPUCore

Path: `/org/modulus/GPUCore`
Bus: system

Methods:
- `ListGPUs() -> []dict` (vendor, model, pciId, driver, version, vulkan, opengl, vaapi)
- `GetHybridConfig() -> dict`
- `SetAppGPU(appId: string, gpu: string) -> void` (Polkit: `org.modulus.gpucore.setappgpu`)
- `GetDriverStatus() -> dict`
- `RunDiagnostics() -> dict`

Signals:
- `GPUChanged()`
- `DriverHealthChanged(status: string)`

## org.modulus.SecureCore

Path: `/org/modulus/SecureCore`
Bus: system

Methods:
- `GetStatus() -> dict` (protection, firewall, updates, integrity)
- `StartScan(path: string, scope: string) -> string` (returns scanId)
- `GetScanResult(scanId: string) -> dict`
- `Quarantine(path: string) -> void` (Polkit: `org.modulus.securecore.quarantine`)
- `RestoreQuarantine(id: string) -> void`
- `GetFirewallRules() -> []dict`
- `SetFirewallRule(rule: dict) -> void` (Polkit)
- `GetSecurityEvents(since: int64) -> []dict`

Signals:
- `ThreatDetected(path: string, threat: string)`
- `ScanCompleted(scanId: string, result: dict)`
- `SecurityStatusChanged(status: dict)`

## org.modulus.WallpaperCore

Path: `/org/modulus/WallpaperCore`
Bus: session

Methods:
- `SetWallpaper(monitor: string, path: string, mode: string) -> void`
- `GetWallpaper(monitor: string) -> dict`
- `Pause() -> void` / `Resume() -> void`
- `SetQuality(level: string) -> void`

Signals:
- `WallpaperChanged(monitor: string, path: string)`

## org.modulus.UpdateManager

Path: `/org/modulus/UpdateManager`
Bus: system

Methods:
- `CheckUpdates() -> []dict`
- `ApplyBaseUpdate() -> void` (Polkit: `org.modulus.updatemanager.applybase`)
- `ApplyFlatpakUpdates() -> void`
- `Rollback() -> void` (Polkit)
- `GetHistory() -> []dict`

Signals:
- `UpdateAvailable(type: string, details: dict)`
- `UpdateProgress(percent: uint8, stage: string)`
- `UpdateCompleted(result: dict)`
- `UpdateFailed(error: string)`

## org.modulus.HardwareCompat

Path: `/org/modulus/HardwareCompat`
Bus: system

Methods:
- `GetInventory() -> dict` (cpu, gpu, storage, network, audio, bt, usb, displays)
- `LookupDevice(vendorId: string, deviceId: string) -> dict`
- `GenerateReport() -> string` (path to report file)

## org.modulus.Diagnostics

Path: `/org/modulus/Diagnostics`
Bus: system

Methods:
- `CollectReport() -> string`
- `GetLogs(service: string, since: int64, limit: uint32) -> []dict`
- `GetMetrics() -> dict` (boot time, mem, cpu, etc.)