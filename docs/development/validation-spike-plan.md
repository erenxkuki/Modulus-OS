# MODULUS OS — ADR-0001 Validation Spike Plan

**Status:** Plan written; execution pending a working Linux build host.
**Last attempted:** 2026-11-06 via RemoteForge (agents offline — see notes).

## Goal

Validate ADR-0001 (Fedora Atomic/Kinoite foundation) before committing. ADR-0001 stays "Recommended (pending)" until all steps pass.

## Prerequisites

- A Linux host (Fedora recommended) with `podman`, network access to `quay.io`, and ~20 GB free disk.
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

## RemoteForge attempt (2026-11-06)

- RemoteForge server brought up locally on Windows (localhost:8787) — OK.
- Two nodes registered (node_mw4ej28s, node_mw3jfwpt) but both heartbeats are stale (~7–21 h old); agent daemons are NOT running, so jobs stay `pending` indefinitely.
- A session was successfully requested/approved/claimed (token obtained), but workspace creation and command execution never completed because no live agent picked up the jobs.
- Conclusion: the spike could NOT be executed remotely in this attempt. The VPS agent must be restarted (or a fresh agent started) before remote execution works.

## What would unblock execution

Option A (recommended): User restarts the agent on the VPS:
```bash
npx remote-forge-cli agent run
```
Then notify me; I'll re-run Steps 1–3 (build + probe tooling) remotely. Steps 4 and 6 require real hardware / reboot, which a remote agent can do but need careful coordination.

Option B: User runs Steps 1–6 manually on any Linux machine and pastes the results; I'll record pass/fail and update ADR-0001.

## Recording results

When executed, append a "Spike results" section here with:
- Date, host, distro/kernel
- Step 1–6 pass/fail + evidence (build log, boot screenshot description, nvidia-smi output, rollback verification)
- Decision: mark ADR-0001 as Accepted, or revisit with a new ADR.