# homelab-tf

Terraform-managed Proxmox homelab.
Right now, there's only 1 module for **enterprise linux distros** testing (AlmaLinux, Ubuntu Server, OpenSUSE) but in the future I'm planning to add more such as Kubernetes Lab and CyberSec (with vLAN, SIEM observability).

## Modules

- [`enterprise/`](./enterprise) — see its [README](./enterprise/README.md) for details

Each module is a standalone Terraform root module: `cd` into it, then `terraform init && terraform apply`.

## Basic Config

- allow `apt update` as a non-enterprise proxmox node, check Eugene Ivanov [blog post](https://eugeneivanov.dev/journal/troubleshooting/fixing-proxmox-enterprise-repository-errors/)
- `apt install libguestfs-tools` (needed for `virt-customize`), so `qemu-guest-agent` is baked in the templates for IP verification and debugging

