# =============================================================================
# Storage Configuration — jol-deploy
# =============================================================================
# Defines storage pools and backup targets for tenant data.
# =============================================================================

terraform {
  required_version = ">= 1.6"
}

variable "backup_pool" {
  description = "Proxmox storage pool for backups"
  type        = string
  default     = "backup-pbs"
}

variable "data_pool" {
  description = "Proxmox storage pool for tenant data"
  type        = string
  default     = "local-lvm"
}

output "storage_config" {
  value = {
    backup_pool = var.backup_pool
    data_pool   = var.data_pool
  }
}
