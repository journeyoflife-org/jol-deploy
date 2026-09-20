# Emergency Procedures

## Complete Service Outage

1. **Assess**: `./scripts/health-check.sh <tenant>` for each tenant
2. **Check infrastructure**: VM up? Docker running? Network OK?
3. **Restart services**: `docker compose restart` per tenant
4. **If VM down**: Restore from PBS snapshot
5. **Notify**: `./robots/notify-bot.sh #jol-alerts "OUTAGE: <description>"`

## Security Incident

1. **Isolate**: Block affected tenant's network access
2. **Assess**: Check audit logs (`/var/log/jol-deploy/audit/`)
3. **Contain**: Rotate any potentially compromised secrets
4. **Recover**: Restore from last known good backup
5. **Report**: File security incident per GDPR Art. 33 (72h notification)

## Data Breach

1. **Contain**: Isolate affected systems
2. **Assess**: Determine scope of breach (which tenants, what data)
3. **Notify**: DPO within 1 hour, supervisory authority within 72 hours (GDPR Art. 33)
4. **Document**: Record all actions taken
5. **Remediate**: Patch vulnerability, rotate credentials
