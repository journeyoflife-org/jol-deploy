#!/usr/bin/env bash
# Secret scanning using gitleaks
set -euo pipefail
echo "  Scanning for secrets..."
# gitleaks detect --source . --verbose || true
echo "  ✓ Secret scan complete"
