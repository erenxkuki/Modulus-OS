#!/usr/bin/env bash
# MODULUS OS — image build script
# STATUS: UNTESTED. Requires a Linux host with podman and network access.
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-modulus-os}"
IMAGE_TAG="${IMAGE_TAG:-dev}"
CONTAINERFILE="${CONTAINERFILE:-Containerfile}"

echo "[modulus] Building image ${IMAGE_NAME}:${IMAGE_TAG} from ${CONTAINERFILE}"

# Build the container image.
podman build \
    --file "${CONTAINERFILE}" \
    --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
    .

echo "[modulus] Build complete: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "[modulus] Next: convert to a bootable disk image (bootc-image-builder) or deploy to an ostree repo."
echo "[modulus] See docs/development/validation-spike-plan.md"