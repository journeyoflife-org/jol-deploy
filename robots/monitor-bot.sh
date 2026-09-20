#!/usr/bin/env bash
# =============================================================================
# monitor-bot.sh — Health monitoring agent
# =============================================================================
# Pings health endpoints for all tenants, alerts on failures.
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTION="${1:-run}"

case "$ACTION" in
  start)
    echo "Starting monitor bot..."
    while true; do
      for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
        [ -f "$tenant_file" ] || continue
        TENANT=$(grep "^tenant_id:" "$tenant_file" | awk "{print \$2}")
        "$REPO_ROOT/scripts/health-check.sh" "$TENANT" 2>/dev/null ||           echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ALERT: $TENANT is unhealthy"
      done
      sleep 60
    done
    ;;
  run)
    echo "Running single monitoring pass..."
    FAILED=0
    for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
      [ -f "$tenant_file" ] || continue
      TENANT=$(grep "^tenant_id:" "$tenant_file" | awk "{print \$2}")
      if ! "$REPO_ROOT/scripts/health-check.sh" "$TENANT" 2>/dev/null; then
        echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ALERT: $TENANT is unhealthy"
        FAILED=$((FAILED + 1))
      fi
    done
    echo "Monitor pass complete. Failed: $FAILED"
    ;;
  *)
    echo "Usage: monitor-bot.sh [start|run]"
    ;;
esac
