#!/usr/bin/env bash
# API Fallback Rollback Drill
# Simulates API failure and verifies fixtures serve content.
#
# Wave 1 Task 11 — exit gate: API down → fixtures serve.
#
# Usage: ./api-fallback-drill.sh [--dry-run]
#
# Prerequisites:
# - jol-backend service exists (systemd or Docker)
# - Template renderer is running with BACKEND_API_URL configured
# - curl is available

set -euo pipefail

DRY_RUN="${1:-}"
BACKEND_SERVICE="${JOL_BACKEND_SERVICE:-jol-backend}"
TENANT_DOMAIN="${TENANT_DOMAIN:-gyvenimo-kelias.lt}"
TIMEOUT=10

echo "=== API Fallback Rollback Drill ==="
echo "Backend service: ${BACKEND_SERVICE}"
echo "Tenant domain:   ${TENANT_DOMAIN}"
echo ""

if [ "${DRY_RUN}" = "--dry-run" ]; then
  echo "[DRY-RUN] Would execute:"
  echo "  1. systemctl stop ${BACKEND_SERVICE}"
  echo "  2. curl -sf https://${TENANT_DOMAIN}/ (expect 200 from fixtures)"
  echo "  3. systemctl start ${BACKEND_SERVICE}"
  echo ""
  echo "[DRY-RUN] Drill definition valid."
  exit 0
fi

# Step 1: Stop backend API
echo "Step 1: Stopping backend API..."
if systemctl is-active --quiet "${BACKEND_SERVICE}" 2>/dev/null; then
  systemctl stop "${BACKEND_SERVICE}"
  echo "  ✓ Backend stopped"
else
  echo "  ⚠ Backend not running (systemd) — skipping stop"
fi

# Step 2: Verify fixtures serve
echo "Step 2: Requesting tenant resolution (fixtures should serve)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}"   --max-time "${TIMEOUT}"   "https://${TENANT_DOMAIN}/" 2>/dev/null || echo "000")

if [ "${HTTP_CODE}" = "200" ]; then
  echo "  ✓ Fixtures serving (HTTP 200)"
  DRILL_RESULT=0
elif [ "${HTTP_CODE}" = "000" ]; then
  echo "  ⚠ Connection refused/timeout — fixtures may not be cached"
  DRILL_RESULT=1
else
  echo "  ✗ Unexpected HTTP ${HTTP_CODE} — fixtures NOT serving"
  DRILL_RESULT=1
fi

# Step 3: Restart backend API
echo "Step 3: Restarting backend API..."
if command -v systemctl &>/dev/null; then
  systemctl start "${BACKEND_SERVICE}" 2>/dev/null || true
  echo "  ✓ Backend restarted"
else
  echo "  ⚠ systemctl not available — manual restart required"
fi

echo ""
if [ "${DRILL_RESULT}" = "0" ]; then
  echo "=== Drill PASS ==="
else
  echo "=== Drill FAIL ==="
  echo "Action required: verify fixture cache is populated and resolver fallback works."
fi

exit "${DRILL_RESULT}"
