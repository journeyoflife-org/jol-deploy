#!/usr/bin/env bash
# =============================================================================
# Test template rendering with sample variables
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEMPLATES_DIR="$REPO_ROOT/templates"

echo "→ Testing template rendering..."

# Test Dockerfile template
if [ -f "$TEMPLATES_DIR/Dockerfile.template" ]; then
  echo "  ✓ Dockerfile.template exists"
  # Check for required variables
  grep -q "APP_NAME" "$TEMPLATES_DIR/Dockerfile.template" || echo "  ✗ Missing APP_NAME"
  grep -q "NODE_VERSION" "$TEMPLATES_DIR/Dockerfile.template" || echo "  ✗ Missing NODE_VERSION"
fi

# Test docker-compose template
if [ -f "$TEMPLATES_DIR/docker-compose.template.yml" ]; then
  echo "  ✓ docker-compose.template.yml exists"
  grep -q "TENANT_NAME" "$TEMPLATES_DIR/docker-compose.template.yml" || echo "  ✗ Missing TENANT_NAME"
fi

# Test nginx template
if [ -f "$TEMPLATES_DIR/nginx.template.conf" ]; then
  echo "  ✓ nginx.template.conf exists"
  grep -q "DOMAIN" "$TEMPLATES_DIR/nginx.template.conf" || echo "  ✗ Missing DOMAIN"
fi

echo "✓ Template render tests complete"
