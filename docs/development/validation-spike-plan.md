# MODULUS OS — ADR-0001 Validation Spike Plan

**Status:** Plan written; execution attempted via RemoteForge; blocked by environment limitations (see below).
**Last attempted:** 2026-11-06.

## Goal

Validate ADR-0001 (Fedora Atomic/Kinoite foundation) before committing. ADR-0001 stays "Recommended (pending)" until all steps pass.

## Prerequisites

- A Linux host (Fedora recommended) with `podman` (rootful or with user namespaces), network access to `quay.io`, and ~20 GB free disk.
- For VM boot test: `qemu`/KVM or VirtualBox + `bootc-image-builder`.
- For NVIDIA+Secure Boot step: a physical machine with NVIDIA GPU and Secure Boot enabled. (VM-only for now per current constraints.)

## Steps

### Step 1 — Build the image
```bash
cd foundation/image-builder
./build.sh
# Expected: image modulus-os:dev built successfully.
```
Pass criteria: build exits 0, image present in podman.

### Step 2 — Convert to bootable disk image (VM test)
```bash
sudo podman run --rm -it --privileged \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v ./output:/output \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type qcow2 localhost/modulus-os:dev
```
Pass criteria: qcow2 produced.

### Step 3 — Boot in VM
Boot the qcow2 in QEMU/KVM or VirtualBox.
Pass criteria:
- Boots to login (SDDM) without manual intervention.
- Network connects (NetworkManager).
- Audio plays (PipeWire).
- Desktop (Plasma 6) renders at the VM's resolution.

### Step 4 — Install NVIDIA drivers (VM, software path)
On a VM without NVIDIA, skip; run on real hardware.
On real hardware with Secure Boot ON:
1. Enroll MOK when prompted by akmods.
2. Reboot, complete MOK enrollment.
3. Verify `nvidia-smi` works and a Proton game launches in Steam.
Pass criteria: no Secure Boot violation; game launches.

### Step 5 — Interrupted update
```bash
# Start an update, then kill the process mid-flight
rpm-ostree upgrade &
sleep 5; kill %1
# Reboot
```
Pass criteria: system still boots into a working deployment.

### Step 6 — Rollback
```bash
# Deploy a deliberately broken image (e.g., add a bad package), reboot, then:
rpm-ostree rollback
# Reboot
```
Pass criteria: previous working deployment restored.

## RemoteForge execution attempt (2026-11-06)

### What worked
- RemoteForge server started locally on Windows (localhost:8787).
- Agent paired successfully (new node `node_mw4xcnus_3a9540a4efcbfc81`, Ubuntu 24.04 / kernel 6.17.0-1011-oracle, x64).
- Session auth flow verified end-to-end: request → approve → claim → active token.
- Workspace creation succeeded.
- Node has a full toolchain: `apt`, `sudo`, `docker`, `node`, `bash`, compilers, etc.
- Successfully installed `podman 5.7.0` via apt.

### What blocked execution
- **Podman cannot run in the container.** `podman build` fails with `cannot clone: Operation not permitted` / `cannot re-exec process` — the container lacks user-namespace capabilities (CAP_SYS_ADMIN / seccomp). This is a nested-container limitation, not a MODULUS issue.
- **No QEMU** available and cannot be installed usefully without KVM access in the container.
- **No `rpm-ostree`/`bootc`/`ostree`** on the host, and installing them on Ubuntu is not practical.
- Conclusion: this VPS is a development container, not a build host. The spike cannot run here.

### Environment findings
- Host: Ubuntu 24.04 (kernel 6.17.0-1011-oracle), x86_64, containerized.
- Available: node 20.20.2, docker 29.9.2 (daemon not running), podman 5.7.0 (installed, unusable due to namespaces), sudo (passwordless), apt.
- Missing: qemu, rpm-ostree, bootc, ostree, podman-with-namespace-support.
- RemoteForge agent command runner uses `spawn(..., { shell: false })`; commands must be invoked via `/usr/bin/bash -c` or `node` directly. Even `echo` fails as a standalone binary (it's a shell builtin). This is a RemoteForge quirk to remember if used again.

## What would unblock execution

Option A (recommended): Run on a real Fedora machine (bare metal or VM with KVM) that has:
- `podman` with working user namespaces (or rootful podman on a real host)
- Network access to `quay.io`
- `qemu`/KVM for VM boot testing (optional but needed for Step 3)
- For Step 4: a physical NVIDIA GPU with Secure Boot enabled

Then execute Steps 1–6 and append results below.

Option B: Use a cloud instance (e.g., a Fedora VM on a cloud provider) with nested virtualization enabled, and run the steps there.

Option C: Keep the Containerfile as-is and validate it on the next available Fedora build host; the image definition is small and reviewable in the meantime.

## Recording results (to be filled when executed)

When executed, append a "Spike results" section with:
- Date, host, distro/kernel
- Step 1–6 pass/fail + evidence (build log, boot observation, nvidia-smi output, rollback verification)
- Decision: mark ADR-0001 as Accepted, or revisit with a new ADR.