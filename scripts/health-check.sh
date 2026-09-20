#!/usr/bin/env bash
# =============================================================================
# health-check.sh — Verify tenant deployment health
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: health-check.sh <tenant>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAX_RETRIES=10
RETRY_INTERVAL=5

echo "→ Health check: $TENANT"

# Find tenant port from config
TENANT_PORT=""
for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
  if grep -q "^tenant_id: ${TENANT}$" "$tenant_file" 2>/dev/null; then
    TENANT_PORT=$(grep "port:" "$tenant_file" | awk "{print \$2}" | head -1)
    break
  fi
done
TENANT_PORT="${TENANT_PORT:-3000}"

for i in $(seq 1 $MAX_RETRIES); do
  if curl -sf "http://localhost:${TENANT_PORT}/health" > /dev/null 2>&1; then
    echo "  ✓ Tenant $TENANT is healthy (port $TENANT_PORT)"
    exit 0
  fi
  echo "  Attempt $i/$MAX_RETRIES — waiting ${RETRY_INTERVAL}s..."
  sleep "$RETRY_INTERVAL"
done

echo "  ✗ Tenant $TENANT failed health check after $MAX_RETRIES attempts"
exit 1
