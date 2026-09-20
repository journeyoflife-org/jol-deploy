# Network Security Policy

## VLAN Segmentation

| VLAN | Purpose | CIDR | Access |
|------|---------|------|--------|
| 20 | Database | 10.20.20.0/24 | VLAN 30, 40 only |
| 30 | LLM stack | 10.30.30.0/24 | VLAN 40 only |
| 40 | AI services / Web | 10.40.40.0/24 | VLAN 30, 60 |
| 60 | Management | 10.60.60.0/24 | All VLANs (admin) |

## Firewall Rules

1. **Default deny** incoming on all VLANs
2. **SSH (22)**: only from VLAN 60 (management)
3. **Application ports**: only from load balancer / reverse proxy
4. **Database ports**: only from application VLAN
5. **Monitoring (9100)**: only from management VLAN
6. **No direct internet** from VLAN 20, 30

## Tenant Isolation

- Each tenant runs in its own Docker network (bridge driver)
- No cross-tenant network access by default
- Inter-tenant communication only via the reverse proxy
