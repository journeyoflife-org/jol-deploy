#!/usr/bin/env bash
# =============================================================================
# rollback.sh — Rollback a tenant to a previous version
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: rollback.sh <tenant> <version>}"
VERSION="${2:?Usage: rollback.sh <tenant> <version>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Rolling back $TENANT to $VERSION ==="
"$REPO_ROOT/deployment/controllers/rollback-controller.sh" "$TENANT" "$VERSION"
