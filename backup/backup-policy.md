# Backup Policy — jol-deploy

## Scope

This policy covers all tenant data, application configurations, and database
state managed by jol-deploy.

## Backup Types

| Type | Frequency | Retention | Storage |
|------|-----------|-----------|---------|
| VM snapshot (PBS) | Daily 03:00 | 7 days | Proxmox Backup Server |
| Database dump | Daily 02:00 | 30 days | /opt/jol/backups/ |
| Application config | Git (versioned) | Permanent | GitHub |
| TLS certificates | On renewal | Until superseded | /etc/letsencrypt/ |
| Tenant data | Daily 04:00 | 30 days | /opt/jol/backups/ |

## RPO/RTO by Environment

| Environment | RPO | RTO |
|-------------|-----|-----|
| Production | 24 hours | 4 hours |
| Staging | 24 hours | 8 hours |
| Development | Best effort | Best effort |

## Verification

- **Weekly**: automated restore test for one random tenant (staging)
- **Monthly**: full DR drill (production → restore to isolated VM)
- **After incident**: immediate restore test for affected tenant
