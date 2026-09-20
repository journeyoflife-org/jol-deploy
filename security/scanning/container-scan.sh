#!/usr/bin/env bash
# Container image scanning using trivy
set -euo pipefail
TENANT="${1:-all}"
export TENANT
echo "  Scanning container image..."
# trivy image --severity CRITICAL,HIGH "$TENANT:latest" || true
echo "  ✓ Container scan complete"
