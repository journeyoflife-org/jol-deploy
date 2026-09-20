#!/usr/bin/env bash
# =============================================================================
# provision-vm.sh — Provision a new VM for tenant hosting
# =============================================================================
set -euo pipefail

VM_NAME="${1:?Usage: provision-vm.sh <vm-name> [vm-id]}"
VM_ID="${2:-}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Provisioning VM: $VM_NAME ==="

# Run Ansible playbook
if [ -n "$VM_ID" ]; then
  ansible-playbook "$REPO_ROOT/infrastructure/ansible/playbooks/provision-vm.yml"     -e "vm_name=$VM_NAME vm_id=$VM_ID"
else
  ansible-playbook "$REPO_ROOT/infrastructure/ansible/playbooks/provision-vm.yml"     -e "vm_name=$VM_NAME"
fi

echo "✓ VM $VM_NAME provisioned"
