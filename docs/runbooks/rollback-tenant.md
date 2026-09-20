# Runbook: Rollback Tenant

## When to Use
A deployment caused issues and needs to be reverted.

## Steps

1. **Identify target version**: Check deployment audit records
2. **Backup current state**: `./backup/backup-before-deploy.sh <tenant>`
3. **Rollback**: `make rollback TENANT=<tenant-id> VERSION=<target>`
4. **Verify**: `make health-check TENANT=<tenant-id>`
5. **Notify**: `./robots/notify-bot.sh #jol-deploy "Rolled back <tenant> to <version>"`

## If Rollback Fails
1. Check database state — may need manual DB rollback
2. Restore from VM snapshot: `qm restore <vmid> <snapshot-id>`
3. Escalate to platform architect
