#!/usr/bin/env bash
# =============================================================================
# scan-all.sh — Run all security scans for a tenant
# =============================================================================
set -euo pipefail

TENANT="${1:-all}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Security Scan Suite ==="
echo "Target: $TENANT"
echo ""

FAILED=0

echo "→ 1/5: SAST (Static Analysis)"
"$SCRIPT_DIR/sast-scan.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 2/5: Dependency scanning"
"$SCRIPT_DIR/dependency-scan.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 3/5: Secret scanning"
"$SCRIPT_DIR/secret-scan.sh" || FAILED=$((FAILED + 1))

echo "→ 4/5: Container image scanning"
"$SCRIPT_DIR/container-scan.sh" "$TENANT" || FAILED=$((FAILED + 1))

echo "→ 5/5: IaC security scanning"
"$SCRIPT_DIR/iac-scan.sh" || FAILED=$((FAILED + 1))

echo ""
if [ "$FAILED" -eq 0 ]; then
  echo "✓ All security scans PASSED"
else
  echo "✗ $FAILED scan(s) FAILED"
  exit 1
fi
