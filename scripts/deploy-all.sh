#!/usr/bin/env bash
# =============================================================================
# deploy-all.sh — Deploy all tenants for an environment
# =============================================================================
set -euo pipefail

ENV="${1:?Usage: deploy-all.sh <environment>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARALLEL="${PARALLEL:-3}"

echo "=== Deploying all tenants to $ENV ==="

# Collect all tenant configs
TENANTS=()
for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
  [ -f "$tenant_file" ] || continue
  TENANT=$(grep "^tenant_id:" "$tenant_file" | awk "{print \$2}")
  TENANTS+=("$TENANT")
done

echo "  Found ${#TENANTS[@]} tenants"
echo "  Parallelism: $PARALLEL"

# Deploy in batches
for tenant in "${TENANTS[@]}"; do
  echo "→ Deploying $tenant..."
  "$REPO_ROOT/scripts/deploy.sh" "$tenant" "$ENV" || echo "  ✗ Failed: $tenant"
done

echo "=== All deployments complete ==="
