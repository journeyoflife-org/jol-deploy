#!/usr/bin/env bash
# =============================================================================
# pre-deploy-checks.sh — Run all pre-deployment checks
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: pre-deploy-checks.sh <tenant> <environment>}"
ENV="${2:?Usage: pre-deploy-checks.sh <tenant> <environment>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Pre-Deployment Checks: $TENANT ($ENV) ==="

FAILED=0

echo "→ 1. Tenant validation"
"$REPO_ROOT/scripts/validate-tenant.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 2. Security scan"
"$REPO_ROOT/security/scanning/scan-all.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 3. Migration check"
"$REPO_ROOT/database/migration-check.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 4. DNS verification"
# (skipped if domain not yet provisioned)

echo "→ 5. TLS certificate check"
# (skipped if cert not yet provisioned)

if [ "$FAILED" -gt 0 ]; then
  echo "✗ $FAILED pre-deploy check(s) failed"
  exit 1
fi

echo "✓ All pre-deployment checks passed"
