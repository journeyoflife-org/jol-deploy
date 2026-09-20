#!/usr/bin/env bash
# =============================================================================
# audit-record.sh — Generate immutable deployment audit record
# =============================================================================
set -euo pipefail

DEPLOY_ID="${1:?Usage: audit-record.sh <deploy-id> <tenant> <env> <status>}"
TENANT="${2:?}"
ENV="${3:?}"
STATUS="${4:?}"

AUDIT_DIR="/var/log/jol-deploy/audit"
mkdir -p "$AUDIT_DIR"

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
COMMIT_SHA="${GITHUB_SHA:-$(git rev-parse HEAD 2>/dev/null || echo 'unknown')}"

cat > "${AUDIT_DIR}/${DEPLOY_ID}.json" << EOF
{
  "deployment_id": "$DEPLOY_ID",
  "tenant": "$TENANT",
  "environment": "$ENV",
  "status": "$STATUS",
  "commit_sha": "$COMMIT_SHA",
  "timestamp": "$TIMESTAMP",
  "operator": "${GITHUB_ACTOR:-$(whoami)}",
  "hostname": "$(hostname)"
}
EOF

echo "✓ Audit record: ${AUDIT_DIR}/${DEPLOY_ID}.json"
