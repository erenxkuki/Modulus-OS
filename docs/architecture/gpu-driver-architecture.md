# MODULUS OS — GPU Driver Architecture

## Detection

GPUCore detects via udev/PCI/sysfs:
- Vendor, model, PCI ID
- Installed driver + version
- Vulkan/OpenGL availability
- Hardware acceleration (VA-API/VDPAU/NVDEC)
- Hybrid graphics topology (iGPU + dGPU)

## Vendor support

### NVIDIA
- Proprietary driver via RPM Fusion/akmods (proven by Bazzite).
- Vulkan (via driver), OpenGL, CUDA (where supported), NVDEC/NVENC.
- Secure Boot: akmods + MOK enrollment (documented UX; validated in spike).
- Never silently replace a working driver; rollback to previous driver version supported.

### AMD
- AMDGPU kernel driver + Mesa (RADV Vulkan, RadeonSI OpenGL).
- VA-API via Mesa.

### Intel
- i915/xe kernel driver + Mesa (ANV Vulkan, Iris OpenGL).
- VA-API via Mesa.

## Hybrid graphics

- Investigate existing PRIME/render-offload infrastructure.
- Provide clear per-app GPU selection in Control Center and Modulus Play.
- Do not assume all laptops support all switching methods; detect and report capability.

## Driver management interface (GPUCore + Control Center)

- Show installed vs recommended driver.
- Install/update/rollback with explicit confirmation.
- Diagnostic report (Vulkan info, glxinfo, dmesg GPU errors).
- Driver health status; never show "healthy" if detection failed.

## Safety

- Only signed/trusted driver packages.
- No arbitrary unsigned driver installs.
- Driver changes are reversible via rollback.