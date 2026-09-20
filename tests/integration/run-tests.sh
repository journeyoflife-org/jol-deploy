#!/usr/bin/env bash
# Integration test runner
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TESTS_DIR="$REPO_ROOT/tests/integration"

echo "=== Integration Tests ==="
FAILED=0

echo "→ Deploy test..."
bash "$TESTS_DIR/test-deploy.sh" || FAILED=$((FAILED + 1))

echo "→ Smoke test..."
bash "$TESTS_DIR/test-smoke.sh" "${TEST_TENANT:-basilica-vilnius}" || FAILED=$((FAILED + 1))

if [ "$FAILED" -eq 0 ]; then
  echo "✓ All integration tests PASSED"
else
  echo "✗ $FAILED integration test(s) FAILED"
  exit 1
fi
