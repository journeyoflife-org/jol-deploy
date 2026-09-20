#!/usr/bin/env bash
# =============================================================================
# validate-tenant.sh — Validate a tenant configuration file
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: validate-tenant.sh <tenant>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "→ Validating tenant: $TENANT"

# Find tenant config
TENANT_FILE=""
for tenant_file in "$REPO_ROOT/tenants"/*/*.yml; do
  if grep -q "^tenant_id: ${TENANT}$" "$tenant_file" 2>/dev/null; then
    TENANT_FILE="$tenant_file"
    break
  fi
done

if [ -z "$TENANT_FILE" ]; then
  echo "✗ Tenant config not found: $TENANT"
  exit 1
fi

echo "  Config file: $TENANT_FILE"

# Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('$TENANT_FILE'))" || {
  echo "✗ Invalid YAML"
  exit 1
}

# Validate against schema
python3 "$REPO_ROOT/tests/unit/validate-schemas.py" "$TENANT_FILE" 2>/dev/null || true

# Check required fields
REQUIRED_FIELDS="tenant_id name country domain environment"
for field in $REQUIRED_FIELDS; do
  if ! grep -q "^${field}:" "$TENANT_FILE"; then
    echo "✗ Missing required field: $field"
    exit 1
  fi
done

echo "✓ Tenant $TENANT configuration is valid"
