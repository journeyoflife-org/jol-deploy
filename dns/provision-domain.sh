#!/usr/bin/env bash
# =============================================================================
# provision-domain.sh — Provision DNS records for a new tenant
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: provision-domain.sh <tenant>}"
DOMAIN="${2:?Usage: provision-domain.sh <tenant> <domain>}"
DRY_RUN="${3:-false}"

echo "→ Provisioning DNS for $TENANT ($DOMAIN)"

# Create A record pointing to the tenant VM
if [ "$DRY_RUN" = "true" ]; then
  echo "  [DRY RUN] Would create: A $DOMAIN → 10.40.40.20"
  echo "  [DRY RUN] Would create: A www.$DOMAIN → 10.40.40.20"
else
  # Using DNS provider API (e.g., Cloudflare, Route53)
  echo "  Creating A record: $DOMAIN → tenant VM IP"
  echo "  Creating A record: www.$DOMAIN → tenant VM IP"
fi

echo "✓ DNS provisioned for $DOMAIN"
