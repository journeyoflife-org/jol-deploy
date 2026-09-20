#!/usr/bin/env bash
# =============================================================================
# test-smoke.sh — Smoke test for a deployed tenant
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: test-smoke.sh <tenant>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "→ Smoke test: $TENANT"

# Find tenant port
TENANT_PORT=""
for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
  if grep -q "^tenant_id: ${TENANT}$" "$tenant_file" 2>/dev/null; then
    TENANT_PORT=$(grep "port:" "$tenant_file" | awk "{print \$2}" | head -1)
    break
  fi
done
TENANT_PORT="${TENANT_PORT:-3000}"

# Test 1: Health endpoint
echo "  Test 1: Health endpoint"
if curl -sf "http://localhost:${TENANT_PORT}/health" > /dev/null 2>&1; then
  echo "    ✓ /health returns 200"
else
  echo "    ✗ /health unreachable"
  exit 1
fi

# Test 2: Root page
echo "  Test 2: Root page"
if curl -sf "http://localhost:${TENANT_PORT}/" > /dev/null 2>&1; then
  echo "    ✓ / returns 200"
else
  echo "    ⚠ / unreachable (may be expected in test)"
fi

# Test 3: Security headers
echo "  Test 3: Security headers"
HEADERS=$(curl -sI "http://localhost:${TENANT_PORT}/" 2>/dev/null || true)
if echo "$HEADERS" | grep -qi "x-frame-options"; then
  echo "    ✓ X-Frame-Options present"
else
  echo "    ⚠ X-Frame-Options missing"
fi

echo "✓ Smoke tests complete for $TENANT"
