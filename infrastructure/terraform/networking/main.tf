# =============================================================================
# Network Configuration — jol-deploy
# =============================================================================
# Defines VLANs, firewall rules, and network policies for tenant isolation.
# =============================================================================

terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.40"
    }
  }
}

variable "vlan_web" {
  description = "VLAN for web servers"
  type        = number
  default     = 40
}

variable "vlan_management" {
  description = "VLAN for management"
  type        = number
  default     = 60
}

variable "vlan_llm" {
  description = "VLAN for LLM stack"
  type        = number
  default     = 30
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to SSH"
  type        = list(string)
  default     = ["10.10.10.0/24", "10.60.60.0/24"]
}

output "network_summary" {
  value = {
    web_vlan        = var.vlan_web
    management_vlan = var.vlan_management
    llm_vlan        = var.vlan_llm
  }
}
