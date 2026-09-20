#!/usr/bin/env bash
# =============================================================================
# backup-before-migration.sh — Create database backup before migration
# =============================================================================
set -euo pipefail

TENANT="${1:?Usage: backup-before-migration.sh <tenant>}"
BACKUP_DIR="/opt/jol/backups/${TENANT}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "→ Creating pre-migration backup for $TENANT"

mkdir -p "$BACKUP_DIR"

# Docker-based database dump
if docker ps --filter "name=${TENANT}" --format "{{.Names}}" | grep -q .; then
  docker exec "${TENANT}-db" pg_dump -U jol_db_user "${TENANT}" |     gzip > "${BACKUP_DIR}/pre-migration-${TIMESTAMP}.sql.gz"
  echo "✓ Backup created: ${BACKUP_DIR}/pre-migration-${TIMESTAMP}.sql.gz"
else
  echo "⚠ No database container found for $TENANT (skipping)"
fi
