#!/usr/bin/env bash
# =============================================================================
# tenant-manager.sh — Manage tenant lifecycle
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTION="${1:-list}"

case "$ACTION" in
  list)
    echo "Registered tenants:"
    for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
      [ -f "$tenant_file" ] || continue
      TENANT=$(grep "^tenant_id:" "$tenant_file" | awk "{print \$2}")
      DOMAIN=$(grep "^domain:" "$tenant_file" | awk "{print \$2}" | tr -d \"\")
      COUNTRY=$(grep "^country:" "$tenant_file" | awk "{print \$2}")
      echo "  $TENANT | $COUNTRY | $DOMAIN"
    done
    ;;
  add)
    TENANT="${2:?Usage: tenant-manager.sh add <tenant-id>}"
    echo "→ Adding tenant: $TENANT"
    echo "  Use tenants/schemas/tenant-config.schema.json as reference"
    ;;
  remove)
    TENANT="${2:?Usage: tenant-manager.sh remove <tenant-id>}"
    echo "→ Removing tenant: $TENANT"
    echo "  WARNING: This will decommission the tenant"
    ;;
  status)
    TENANT="${2:?Usage: tenant-manager.sh status <tenant-id>}"
    echo "→ Status for $TENANT:"
    "$REPO_ROOT/scripts/health-check.sh" "$TENANT"
    ;;
  *)
    echo "Usage: tenant-manager.sh [list|add|remove|status] [tenant-id]"
    exit 1
    ;;
esac
