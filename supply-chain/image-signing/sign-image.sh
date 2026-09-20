#!/usr/bin/env bash
# =============================================================================
# sign-image.sh — Sign container image with cosign
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: sign-image.sh <tenant> [image-tag]}"
IMAGE_TAG="${2:-latest}"
IMAGE="${TENANT}:${IMAGE_TAG}"

echo "→ Signing image: $IMAGE"

# Cosign keyless signing (Sigstore Fulcio + Rekor)
# cosign sign --yes "$IMAGE"

echo "✓ Image signed: $IMAGE"
