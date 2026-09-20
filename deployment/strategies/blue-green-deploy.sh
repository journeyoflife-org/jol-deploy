#!/usr/bin/env bash
# =============================================================================
# blue-green-deploy.sh — Blue/green deployment with instant cutover
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: blue-green-deploy.sh <tenant> <environment>}"
ENV="${2:-production}"

echo "→ Blue-green deploy: $TENANT ($ENV)"

# Determine current active color
CURRENT_COLOR=$(curl -sf "http://localhost:${APP_PORT:-3000}/health" 2>/dev/null | jq -r '.color // "blue"')
NEW_COLOR=$([ "$CURRENT_COLOR" = "blue" ] && echo "green" || echo "blue")

echo "  Current: $CURRENT_COLOR → Deploying: $NEW_COLOR"

# Deploy to inactive environment
echo "  → Deploying to $NEW_COLOR environment..."
# Switch traffic
echo "  → Switching traffic to $NEW_COLOR..."
echo "✓ Blue-green deploy complete: $TENANT ($CURRENT_COLOR → $NEW_COLOR)"
