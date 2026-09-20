# Runbook: Backup & Restore

## Backup Verification

```bash
# Check latest backup exists
ls -la /opt/jol/backups/<tenant>/

# Verify backup integrity
gunzip -t /opt/jol/backups/<tenant>/latest.sql.gz
```

## Restore Procedure

```bash
# 1. Stop the tenant
cd /opt/jol/tenants/<tenant>
docker compose stop app

# 2. Restore database
gunzip -c /opt/jol/backups/<tenant>/latest.sql.gz | \
  docker exec -i <tenant>-db psql -U jol_db_user <tenant>

# 3. Restore files
tar xzf /opt/jol/backups/<tenant>/files-latest.tar.gz -C /opt/jol/tenants/<tenant>/

# 4. Start the tenant
docker compose start app

# 5. Verify
curl -sf http://localhost:<port>/health
```
