# enterprise

Terraform module cloning cloud-init templates into Enterprise VMs on node `cg-pve`.

`generate_enterprise_templates.sh` builds the cloud-init VM templates (IDs 9000-9002).

## What it creates

| VM           | ID  | Template |
|--------------|-----|----------|
| ent-alma     | 101 | 9000     |
| ent-opensuse | 102 | 9001     |
| ent-ubuntu   | 103 | 9002     |

Each VM: 2 cores (host), 2 GB RAM, 30 GB disk on `local-lvm`, DHCP on `vmbr0`,
cloud-init user `capitan` with your `~/.ssh/id_ed25519.pub`.

## Usage

Requires Terraform >= 1.6 and the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox) provider.

    cp terraform.tfvars.example terraform.tfvars  # set endpoint + API token
    terraform init
    terraform apply

Outputs include assigned DHCP IPs (`vm_ips`) and ready-to-run SSH commands (`ssh_commands`).
