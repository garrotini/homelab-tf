# enterprise

Terraform module cloning cloud-init templates into Enterprise VMs (AlmaLinux, OpenSUSE, UbuntuServer) on a proxmox node.

`generate_enterprise_templates.sh` builds the cloud-init VM templates (IDs 9000-9002).

## What it creates

| VM           | ID  | Template |
|--------------|-----|----------|
| ent-alma     | 101 | 9000     |
| ent-opensuse | 102 | 9001     |
| ent-ubuntu   | 103 | 9002     |

Each VM: 2 cores (host), 2 GB RAM, 30 GB disk on `local-lvm`, DHCP on `vmbr0`,
cloud-init user `capitan` with your `~/.ssh/id_ed25519.pub`.

## Requirements

- Terraform >= 1.6
- [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox) provider

## Usage

``` hcl
    cp terraform.tfvars.example terraform.tfvars  # set endpoint + API token
    terraform init
    terraform plan
    terraform apply
```

Outputs include assigned DHCP IPs (`vm_ips`) and ready-to-run SSH commands (`ssh_commands`).


