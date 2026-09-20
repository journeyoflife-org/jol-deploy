#!/usr/bin/env bash
# =============================================================================
# rolling-deploy.sh — Zero-downtime rolling deployment
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: rolling-deploy.sh <tenant> <environment>}"
ENV="${2:-production}"

echo "→ Rolling deploy: $TENANT ($ENV)"

# Deploy new containers one at a time, waiting for health
cd "/opt/jol/tenants/$TENANT"
docker compose pull
docker compose up -d --no-deps --build app
echo "→ Waiting for container to become healthy..."

ATTEMPTS=0
MAX_ATTEMPTS=30
while [ "$ATTEMPTS" -lt "$MAX_ATTEMPTS" ]; do
  if curl -sf "http://localhost:${APP_PORT:-3000}/health" > /dev/null 2>&1; then
    echo "✓ Container healthy"
    docker compose up -d --no-deps nginx
    echo "✓ Rolling deploy complete"
    exit 0
  fi
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 2
done

echo "✗ Container did not become healthy within $((MAX_ATTEMPTS * 2))s"
exit 1
