#!/usr/bin/env bash
# =============================================================================
# rollback-procedures.sh — Tenant rollback procedures
# =============================================================================
set -euo pipefail

TENANT="${1:-}"
ACTION="${1:-verify}"
VERSION="${2:-}"

case "$ACTION" in
  verify)
    TENANT="${2:-${TENANT}}"
    VERSION="${3:-${VERSION}}"
    echo "→ Verifying rollback target: $TENANT → $VERSION"
    # Check if the target image/tag exists
    docker image inspect "${TENANT}:${VERSION}" > /dev/null 2>&1 || {
      echo "✗ Image ${TENANT}:${VERSION} not found locally"
      echo "  Attempting pull..."
      docker pull "${TENANT}:${VERSION}" || { echo "✗ Cannot pull ${TENANT}:${VERSION}"; exit 1; }
    }
    echo "✓ Target version verified"
    ;;
  execute)
    TENANT="${2:-${TENANT}}"
    VERSION="${3:-${VERSION}}"
    echo "→ Executing rollback: $TENANT → $VERSION"
    cd "/opt/jol/tenants/$TENANT"
    # Update compose to use target version
    export APP_VERSION="$VERSION"
    docker compose pull
    docker compose up -d --no-deps
    echo "✓ Rollback executed"
    ;;
  *)
    echo "Usage: rollback-procedures.sh <verify|execute> <tenant> <version>"
    exit 1
    ;;
esac
