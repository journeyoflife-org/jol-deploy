# =============================================================================
# Proxmox VM Provisioning — jol-deploy
# =============================================================================
# Creates VMs for JOL spoke website hosting on the Proxmox cluster.
# Requires: PM_API_URL, PM_API_TOKEN_ID, PM_API_TOKEN_SECRET env vars.
# =============================================================================

terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.40"
    }
  }

  backend "s3" {
    bucket = "jol-terraform-state"
    key    = "jol-deploy/proxmox/terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "vm_name" {
  description = "VM hostname"
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID"
  type        = number
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 50
}

variable "vm_vlan_tag" {
  description = "VLAN tag for network isolation"
  type        = number
  default     = 40
}

variable "template_name" {
  description = "Proxmox template to clone from"
  type        = string
  default     = "ubuntu-24.04-cloudinit"
}

variable "target_node" {
  description = "Proxmox node to create VM on"
  type        = string
  default     = "pve-prod-hv01"
}

resource "proxmox_virtual_environment_vm" "tenant_vm" {
  name      = var.vm_name
  node_name = var.target_node
  vm_id     = var.vm_id

  cpu {
    cores = var.vm_cores
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = var.vm_disk_size
    file_format  = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = var.vm_vlan_tag
  }

  clone {
    vm_id = data.proxmox_virtual_environment_vm.template.vm_id
  }
}

data "proxmox_virtual_environment_vm" "template" {
  node_name = var.target_node
  vm_id     = 9000 # Template VM ID
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data      = templatefile("${path.module}/cloud-init-userdata.yaml", { hostname = var.vm_name })
    file_name = "${var.vm_name}-cloud-init.yaml"
  }
}

output "vm_ip" {
  value       = proxmox_virtual_environment_vm.tenant_vm.ipv4_addresses
  description = "IP addresses of the created VM"
}
