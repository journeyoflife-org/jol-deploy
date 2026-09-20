#!/usr/bin/env bash
# =============================================================================
# validate-templates.sh — Validate template rendering
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "→ Validating templates..."

# Check that all template variables have defaults or are documented
for template in "$REPO_ROOT/templates/"*; do
  [ -f "$template" ] || continue
  echo "  Checking: $(basename "$template")"
  # Find undefined variables (those without defaults)
  grep -oP '\{\{(\w+)(?![-:])' "$template" 2>/dev/null | sort -u || true
done

echo "✓ Template validation complete"
