#!/usr/bin/env bash
# =============================================================================
# verify-dns.sh — Verify DNS records resolve correctly
# =============================================================================
set -euo pipefail

DOMAIN="${1:?Usage: verify-dns.sh <domain>}"
EXPECTED_IP="${2:?Usage: verify-dns.sh <domain> <expected-ip>}"

echo "→ Verifying DNS for $DOMAIN (expect: $EXPECTED_IP)"

# Check A record
RESOLVED=$(dig +short "$DOMAIN" A 2>/dev/null | head -1)
if [ "$RESOLVED" = "$EXPECTED_IP" ]; then
  echo "  ✓ A record: $DOMAIN → $RESOLVED"
else
  echo "  ✗ A record mismatch: expected $EXPECTED_IP, got ${RESOLVED:-'(none)'}"
  exit 1
fi

# Check www subdomain
RESOLVED_WWW=$(dig +short "www.$DOMAIN" A 2>/dev/null | head -1)
if [ "$RESOLVED_WWW" = "$EXPECTED_IP" ]; then
  echo "  ✓ A record: www.$DOMAIN → $RESOLVED_WWW"
else
  echo "  ⚠ www subdomain: ${RESOLVED_WWW:-'(not configured)'}"
fi

echo "✓ DNS verification complete"
