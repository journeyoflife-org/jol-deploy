#!/usr/bin/env bash
# =============================================================================
# certificate-check.sh — Check TLS certificate status for a domain
# =============================================================================
set -euo pipefail

DOMAIN="${1:?Usage: certificate-check.sh <domain>}"
WARN_DAYS="${2:-30}"

echo "→ Checking TLS certificate for $DOMAIN"

# Get certificate expiry
EXPIRY=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN":443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

if [ -z "$EXPIRY" ]; then
  echo "  ✗ Cannot retrieve certificate for $DOMAIN"
  exit 1
fi

EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null || date -j -f "%b %d %T %Y %Z" "$EXPIRY" +%s 2>/dev/null)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

if [ "$DAYS_LEFT" -lt 0 ]; then
  echo "  ✗ EXPIRED ($EXPIRY)"
  exit 1
elif [ "$DAYS_LEFT" -lt "$WARN_DAYS" ]; then
  echo "  ⚠ Expires in $DAYS_LEFT days ($EXPIRY)"
else
  echo "  ✓ Valid for $DAYS_LEFT days (expires: $EXPIRY)"
fi
