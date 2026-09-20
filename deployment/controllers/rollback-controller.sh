#!/usr/bin/env bash
# =============================================================================
# rollback-controller.sh — Orchestrates tenant rollback
# =============================================================================
# Usage: rollback-controller.sh <tenant> <target-version>
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: rollback-controller.sh <tenant> <target-version>}"
TARGET_VERSION="${2:?Usage: rollback-controller.sh <tenant> <target-version>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ROLLBACK: $TENANT → $TARGET_VERSION"

# Step 1: Verify target version exists
echo "→ Verifying target version $TARGET_VERSION..."
"$REPO_ROOT/deployment/rollback/rollback-procedures.sh" verify "$TENANT" "$TARGET_VERSION"

# Step 2: Database rollback (if needed)
echo "→ Checking database migration state..."
"$REPO_ROOT/database/rollback-policy.sh" "$TENANT" "$TARGET_VERSION" || true

# Step 3: Application rollback
echo "→ Rolling back application..."
"$REPO_ROOT/deployment/rollback/rollback-procedures.sh" execute "$TENANT" "$TARGET_VERSION"

# Step 4: Verify rollback
echo "→ Verifying rollback..."
"$REPO_ROOT/scripts/health-check.sh" "$TENANT"

# Step 5: Audit record
echo "→ Recording rollback..."
"$REPO_ROOT/scripts/audit-record.sh" "ROLLBACK-${TENANT}-$(date +%s)" "$TENANT" "production" "ROLLBACK:${TARGET_VERSION}"

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ROLLBACK complete: $TENANT → $TARGET_VERSION"
