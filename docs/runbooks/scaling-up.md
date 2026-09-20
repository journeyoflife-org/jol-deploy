# Runbook: Scale Up Infrastructure

## When to Use
Current VMs are at capacity (CPU > 70%, Memory > 80%, Disk > 80%).

## Steps

1. **Assess**: Check current resource usage
   ```bash
   # On the VM
   htop  # CPU/Memory
   df -h  # Disk
   docker stats  # Container resources
   ```

2. **Provision new VM**:
   ```bash
   make provision-vm VM_NAME=her-web-lt0N VM_ID=<next-id>
   ```

3. **Configure**:
   ```bash
   ansible-playbook infrastructure/ansible/playbooks/deploy-tenant.yml \
     -i infrastructure/ansible/inventories/production/hosts.yml
   ```

4. **Migrate tenants** (if needed):
   - Deploy to new VM
   - Update DNS/routing
   - Verify health
   - Remove from old VM
