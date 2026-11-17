#!/bin/bash

# !!! THIS needs to run in the Proxmox Node !!!
# 0. Install libguestfs-tools and verify virt-customize exists
apt update && apt install -y libguestfs-tools

# 1. AlmaLinux 9 (Template 9000)
wget -O alma9.qcow2 https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
virt-customize -a alma9.qcow2 --install qemu-guest-agent --run-command 'systemctl enable qemu-guest-agent'
qm create 9000 --name "tpl-almalinux-9" --memory 2048 --cores 2 --cpu host --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single
qm importdisk 9000 alma9.qcow2 local-lvm
qm set 9000 --scsi0 local-lvm:vm-9000-disk-0,discard=on,ssd=1 --ide2 local-lvm:cloudinit --boot order=scsi0 --serial0 socket --vga serial0 --agent enabled=1
qm resize 9000 scsi0 30G && qm template 9000

# 2. openSUSE Leap 15.6 (Template 9001 - qemu-guest-agent already included)
wget -O opensuse.qcow2 https://download.opensuse.org/distribution/leap/15.6/appliances/openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2
qm create 9001 --name "tpl-opensuse-leap" --memory 2048 --cores 2 --cpu host --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single
qm importdisk 9001 opensuse.qcow2 local-lvm
qm set 9001 --scsi0 local-lvm:vm-9001-disk-0,discard=on,ssd=1 --ide2 local-lvm:cloudinit --boot order=scsi0 --serial0 socket --vga serial0 --agent enabled=1
qm resize 9001 scsi0 30G && qm template 9001

# 3. Ubuntu Server 24.04 LTS (Template 9002)
wget -O ubuntu2404.img https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
virt-customize -a ubuntu2404.img --install qemu-guest-agent --run-command 'systemctl enable qemu-guest-agent'
qm create 9002 --name "tpl-ubuntu-2404" --memory 2048 --cores 2 --cpu host --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single
qm importdisk 9002 ubuntu2404.img local-lvm
qm set 9002 --scsi0 local-lvm:vm-9002-disk-0,discard=on,ssd=1 --ide2 local-lvm:cloudinit --boot order=scsi0 --serial0 socket --vga serial0 --agent enabled=1
qm resize 9002 scsi0 30G && qm template 9002

# Clean up downloaded files
rm -f alma9.qcow2 opensuse.qcow2 ubuntu2404.img


