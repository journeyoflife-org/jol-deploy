# Scaling Guide

## Current Capacity

| Resource | Current | Maximum |
|----------|---------|---------|
| VMs (her-prod-lt01) | 1 | 10 |
| Tenants per VM | ~20 | ~50 |
| Total tenants | 2 | 500 |

## Scaling Triggers

- CPU > 70% sustained → add VM
- Memory > 80% sustained → add VM or increase RAM
- Disk > 80% → expand storage
- Tenant count > 20 per VM → add VM

## Adding a New Web Server VM

```bash
# 1. Provision VM
make provision-vm VM_NAME=her-web-lt02 VM_ID=103

# 2. Configure with Ansible
ansible-playbook infrastructure/ansible/playbooks/deploy-tenant.yml \
  -i infrastructure/ansible/inventories/production/hosts.yml \
  -e tenant=<tenant-id>

# 3. Update tenant config to point to new VM
```

## When to Consider Kubernetes

- Tenant count > 200
- Need auto-scaling based on traffic
- Multi-region deployment required
- Complex service mesh needed
