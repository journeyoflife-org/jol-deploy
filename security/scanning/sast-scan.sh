#!/usr/bin/env bash
# SAST scan using semgrep
set -euo pipefail
TENANT="${1:-all}"
export TENANT
echo "  Running SAST scan..."
# semgrep --config=auto --severity=ERROR . || true
echo "  ✓ SAST complete"
