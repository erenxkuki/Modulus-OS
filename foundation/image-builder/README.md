# MODULUS OS — Image Builder

**Status: draft, untested.** This directory defines how the MODULUS OS base image is built. Nothing here has been executed yet.

## Prerequisites

- A Linux host (Fedora recommended) or a VM with:
  - `podman` (or `buildah`)
  - Network access to `quay.io`
  - `bootc-image-builder` for producing bootable disk images (optional, for VM testing)
- At least 20 GB free disk space.

## Build

```bash
cd foundation/image-builder
./build.sh
```

## Convert to a bootable image (for VM testing)

```bash
# Produces a qcow2/iso you can boot in QEMU/KVM or VirtualBox
sudo podman run --rm -it --privileged \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v ./output:/output \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 \
    localhost/modulus-os:dev
```

## Validation

See `docs/development/validation-spike-plan.md`. The image is not considered valid until that spike passes.