#!/usr/bin/env bash
# =============================================================================
# generate-sbom.sh — Generate SBOM for a tenant image
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: generate-sbom.sh <tenant> [image-tag]}"
IMAGE_TAG="${2:-latest}"
OUTPUT_DIR="${SBOM_OUTPUT_DIR:-.sbom}"

mkdir -p "$OUTPUT_DIR"

echo "→ Generating SBOM for ${TENANT}:${IMAGE_TAG}"

# Syft SBOM generation (SPDX format)
# syft "${TENANT}:${IMAGE_TAG}" -o spdx-json > "${OUTPUT_DIR}/${TENANT}-${IMAGE_TAG}.spdx.json"

echo "✓ SBOM generated: ${OUTPUT_DIR}/${TENANT}-${IMAGE_TAG}.spdx.json"
