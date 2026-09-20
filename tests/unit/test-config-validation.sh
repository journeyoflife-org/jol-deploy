#!/usr/bin/env bash
# =============================================================================
# Test configuration file validation
# =============================================================================
# Validates all YAML files EXCEPT:
# - templates/ (contain {{variables}} that aren't valid YAML until rendered)
# - tls/cert-manager-config.yml (Kubernetes multi-document YAML)
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "→ Testing config validation..."

FAILED=0
CHECKED=0

while IFS= read -r file; do
  # Skip templates (contain {{}} variables)
  [[ "$file" == */templates/* ]] && continue
  # Skip Kubernetes multi-document YAML
  [[ "$file" == *cert-manager-config* ]] && continue

  CHECKED=$((CHECKED + 1))
  if ! python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
    echo "  ✗ Invalid YAML: $file"
    FAILED=$((FAILED + 1))
  fi
done < <(find "$REPO_ROOT" -name "*.yml" -o -name "*.yaml" | grep -v .venv | grep -v node_modules | grep -v .git)

if [ "$FAILED" -eq 0 ]; then
  echo "✓ All $CHECKED config files valid"
else
  echo "✗ $FAILED/$CHECKED config(s) invalid"
  exit 1
fi
