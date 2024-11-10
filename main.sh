#!/bin/bash

VERSION="jammy"
VMID="5000"
IMAGE_NAME=$VERSION-server-cloudimg-amd64.img
cd /var/lib/vz/template/iso
#virt-customize -a $IMAGE_NAME --install qemu-guest-agent
qm create $VMID --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk $VMID $IMAGE_NAME local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VMID-disk-0
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --name $VERSION-ci-template
qm template $VMID
