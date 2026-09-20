#!/usr/bin/env bash
# =============================================================================
# tls-renewal.sh — Renew TLS certificates for tenant domains
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: tls-renewal.sh <tenant>}"
DOMAIN="${2:?Usage: tls-renewal.sh <tenant> <domain>}"
DRY_RUN="${3:-false}"

echo "→ Renewing TLS certificate for $DOMAIN"

if [ "$DRY_RUN" = "true" ]; then
  echo "  [DRY RUN] Would run: certbot certonly --webroot -w /var/www/certbot -d $DOMAIN"
else
  certbot certonly --webroot -w /var/www/certbot -d "$DOMAIN" --non-interactive --agree-tos
  # Reload nginx to pick up new cert
  docker exec "${TENANT}-nginx" nginx -s reload 2>/dev/null || true
fi

echo "✓ TLS renewal complete for $DOMAIN"
