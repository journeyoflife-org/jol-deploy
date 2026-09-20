#!/usr/bin/env bash
# =============================================================================
# Unit test runner
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TESTS_DIR="$REPO_ROOT/tests/unit"

echo "=== Unit Tests ==="
FAILED=0

echo "→ Schema validation..."
python3 "$TESTS_DIR/validate-schemas.py" || FAILED=$((FAILED + 1))

echo "→ Template rendering..."
bash "$TESTS_DIR/test-template-render.sh" || FAILED=$((FAILED + 1))

echo "→ Config validation..."
bash "$TESTS_DIR/test-config-validation.sh" || FAILED=$((FAILED + 1))

if [ "$FAILED" -eq 0 ]; then
  echo "✓ All unit tests PASSED"
else
  echo "✗ $FAILED unit test(s) FAILED"
  exit 1
fi
