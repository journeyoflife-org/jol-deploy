#!/usr/bin/env bash
# =============================================================================
# deploy.sh — Deploy a single tenant
# =============================================================================
# Usage: deploy.sh <tenant> <environment>
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: deploy.sh <tenant> <environment>}"
ENV="${2:?Usage: deploy.sh <tenant> <environment>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Deploying $TENANT to $ENV ==="

# Load tenant config
TENANT_CONFIG="$REPO_ROOT/tenants"
for country_dir in "$TENANT_CONFIG"/*/; do
  if [ -f "${country_dir}${TENANT}.yml" ]; then
    TENANT_FILE="${country_dir}${TENANT}.yml"
    break
  fi
done

if [ -z "${TENANT_FILE:-}" ]; then
  echo "✗ Tenant config not found: $TENANT"
  exit 1
fi

echo "  Config: $TENANT_FILE"
echo "  Environment: $ENV"

# Run the deployment controller
"$REPO_ROOT/deployment/controllers/deploy-controller.sh" "$TENANT" "$ENV"
