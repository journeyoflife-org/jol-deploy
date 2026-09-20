#!/usr/bin/env bash
# =============================================================================
# generate-provenance.sh — Generate SLSA provenance attestation
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: generate-provenance.sh <tenant>}"
COMMIT_SHA="${GITHUB_SHA:-$(git rev-parse HEAD 2>/dev/null || echo 'unknown')}"
BUILD_ID="${GITHUB_RUN_ID:-$(date +%s)}"

echo "→ Generating provenance for $TENANT"
echo "  Commit: $COMMIT_SHA"
echo "  Build: $BUILD_ID"

cat << EOF
{
  "tenant": "$TENANT",
  "commit_sha": "$COMMIT_SHA",
  "build_id": "$BUILD_ID",
  "builder": "jol-deploy-ci",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "materials": [
    {
      "uri": "https://github.com/journeyoflife-org/${TENANT}",
      "digest": {"sha1": "$COMMIT_SHA"}
    }
  ]
}
EOF

echo "✓ Provenance generated"
