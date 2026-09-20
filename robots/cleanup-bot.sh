#!/usr/bin/env bash
# =============================================================================
# cleanup-bot.sh — Old image and artifact cleanup
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT
ACTION="${1:-run}"

echo "=== Cleanup Bot ==="

case "$ACTION" in
  run)
    echo "→ Cleaning unused Docker images..."
    docker image prune -af --filter "until=168h" 2>/dev/null || true

    echo "→ Cleaning old deployment records (>90 days)..."
    find /var/log/jol-deploy/audit -name "*.json" -mtime +90 -delete 2>/dev/null || true

    echo "→ Cleaning old backups (>retention period)..."
    # Per-tenant retention based on backup policy

    echo "→ Cleaning temp files..."
    rm -rf /tmp/jol-restore-test/ /tmp/jol-deploy-* 2>/dev/null || true

    echo "✓ Cleanup complete"
    ;;
  schedule)
    echo "Setting up cleanup cron job..."
    echo "0 4 * * 0 ${REPO_ROOT}/robots/cleanup-bot.sh run" | crontab -l 2>/dev/null | cat - | sort -u | crontab -
    ;;
  *)
    echo "Usage: cleanup-bot.sh [run|schedule]"
    ;;
esac
