terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.122.0"
    }
  }
}

variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
}

locals {
  enterprise_vms = {
    "ent-alma"     = { vm_id = 101, template_id = 9000 }
    "ent-opensuse" = { vm_id = 102, template_id = 9001 }
    "ent-ubuntu"   = { vm_id = 103, template_id = 9002 }
  }

  vm_ipv4_map = {
    for name, vm in proxmox_virtual_environment_vm.enterprise_nodes :
    name => try(
      [for ip in flatten(vm.ipv4_addresses) : ip if ip != "127.0.0.1"][0],
      "pending..."
    )
  }
}

resource "proxmox_virtual_environment_vm" "enterprise_nodes" {
  for_each  = local.enterprise_vms
  name      = each.key
  node_name = "cg-pve"
  vm_id     = each.value.vm_id

  clone {
    vm_id = each.value.template_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 30
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "capitan"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }
  }
}

output "vm_ips" {
  description = "DHCP IPv4 addresses assigned to each Enterprise VM"
  value       = local.vm_ipv4_map
}

output "ssh_commands" {
  description = "Ready-to-run SSH commands for each VM"
  value = {
    for name, ip in local.vm_ipv4_map :
    name => "ssh capitan@${ip}"
  }
}

