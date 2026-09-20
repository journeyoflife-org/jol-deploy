# Runbook: Add New Tenant

## When to Use
Adding a new spoke website to the platform.

## Steps

1. **Create tenant config**: `tenants/<country>/<tenant-id>.yml`
2. **Validate**: `make validate-tenant TENANT=<tenant-id>`
3. **Provision DNS**: `./dns/provision-domain.sh <tenant-id> <domain>`
4. **Deploy**: `make deploy TENANT=<tenant-id> ENV=production`
5. **Verify**: `make health-check TENANT=<tenant-id>`
6. **Monitor**: Check Grafana dashboard for new tenant

## Rollback
Remove tenant config and run: `./scripts/rollback.sh <tenant-id> <previous-version>`
