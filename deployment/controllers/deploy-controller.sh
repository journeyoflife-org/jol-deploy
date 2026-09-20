#!/usr/bin/env bash
# =============================================================================
# deploy-controller.sh — Main deployment orchestrator
# =============================================================================
# Coordinates the full deployment pipeline:
#   validate → backup → build → scan → deploy → verify → audit
# Usage: deploy-controller.sh <tenant> <environment> [strategy]
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: deploy-controller.sh <tenant> <environment> [strategy]}"
ENV="${2:?Usage: deploy-controller.sh <tenant> <environment> [strategy]}"
STRATEGY="${3:-rolling}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEPLOY_LOG="/var/log/jol-deploy/${TENANT}-$(date +%Y%m%d-%H%M%S).log"
DEPLOY_ID="${TENANT}-${ENV}-$(date +%Y%m%d-%H%M%S)"

# --- Logging ---
log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*" | tee -a "$DEPLOY_LOG"; }
fail() { log "FAIL: $*"; exit 1; }

# --- Pre-flight ---
log "=== Deployment $DEPLOY_ID ==="
log "Tenant: $TENANT | Environment: $ENV | Strategy: $STRATEGY"

log "→ Step 1/9: Validate tenant configuration"
"$REPO_ROOT/scripts/validate-tenant.sh" "$TENANT" || fail "Tenant validation failed"

log "→ Step 2/9: Pre-deployment backup"
"$REPO_ROOT/backup/backup-before-deploy.sh" "$TENANT" || fail "Backup failed"

log "→ Step 3/9: Build container image"
"$REPO_ROOT/scripts/build-image.sh" "$TENANT" || fail "Build failed"

log "→ Step 4/9: Security scanning"
"$REPO_ROOT/security/scanning/scan-all.sh" "$TENANT" || fail "Security scan failed"

log "→ Step 5/9: Deploy ($STRATEGY)"
case "$STRATEGY" in
  rolling)   "$REPO_ROOT/deployment/strategies/rolling-deploy.sh" "$TENANT" "$ENV" ;;
  canary)    "$REPO_ROOT/deployment/strategies/canary-deploy.sh" "$TENANT" "$ENV" ;;
  blue-green) "$REPO_ROOT/deployment/strategies/blue-green-deploy.sh" "$TENANT" "$ENV" ;;
  *)         fail "Unknown strategy: $STRATEGY" ;;
esac

log "→ Step 6/9: Health check"
"$REPO_ROOT/scripts/health-check.sh" "$TENANT" || fail "Health check failed"

log "→ Step 7/9: Smoke tests"
"$REPO_ROOT/tests/integration/test-smoke.sh" "$TENANT" || fail "Smoke tests failed"

log "→ Step 8/9: Security verification"
"$REPO_ROOT/security/scanning/post-deploy-verify.sh" "$TENANT" || fail "Security verification failed"

log "→ Step 9/9: Generate audit record"
"$REPO_ROOT/scripts/audit-record.sh" "$DEPLOY_ID" "$TENANT" "$ENV" "SUCCESS"

log "=== Deployment $DEPLOY_ID completed successfully ==="
