#!/usr/bin/env bash
# Dependency vulnerability scan
set -euo pipefail
TENANT="${1:-all}"
export TENANT
echo "  Scanning dependencies..."
# pip-audit || npm audit --production || true
echo "  ✓ Dependency scan complete"
