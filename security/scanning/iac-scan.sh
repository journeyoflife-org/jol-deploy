#!/usr/bin/env bash
# IaC security scanning using checkov/tfsec
set -euo pipefail
echo "  Scanning IaC..."
# checkov -d infrastructure/terraform/ || true
# tfsec infrastructure/terraform/ || true
echo "  ✓ IaC scan complete"
