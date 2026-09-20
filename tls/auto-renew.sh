#!/usr/bin/env bash
# =============================================================================
# auto-renew.sh — Automatic TLS certificate renewal for all tenants
# =============================================================================
# Designed to run as a daily cron job.
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="/var/log/jol-deploy/tls-renewal-$(date +%Y%m%d).log"

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*" | tee -a "$LOG_FILE"; }

log "=== TLS Auto-Renewal ==="

# Find all tenant configs
for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
  [ -f "$tenant_file" ] || continue
  DOMAIN=$(grep "^domain:" "$tenant_file" | awk "{print \$2}" | tr -d \"\")
  TENANT=$(grep "^tenant_id:" "$tenant_file" | awk "{print \$2}")

  if [ -n "$DOMAIN" ]; then
    log "Checking $DOMAIN ($TENANT)..."
    # Check if cert expires within 30 days
    if "$REPO_ROOT/dns/certificate-check.sh" "$DOMAIN" 30 2>&1 | grep -q "⚠\|✗"; then
      log "  → Renewing..."
      "$REPO_ROOT/dns/tls-renewal.sh" "$TENANT" "$DOMAIN" || log "  ✗ Renewal failed"
    fi
  fi
done

log "=== TLS Auto-Renewal complete ==="
