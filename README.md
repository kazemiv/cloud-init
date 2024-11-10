create cloudinit in proxmox

#!/bin/bash

VERSION="{{ version }}"
VMID="{{ image_id + pve_id | default(0) | int }}"
IMAGE_URL=https://cloud-images.ubuntu.com/$VERSION/current/$VERSION-server-cloudimg-amd64.img
IMAGE_NAME=$VERSION-server-cloudimg-amd64.img

cd /tmp
wget -nc -O $IMAGE_NAME $IMAGE_URL
virt-customize -a $IMAGE_NAME --install qemu-guest-agent
qm create $VMID --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk $VMID $IMAGE_NAME local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VMID-disk-0
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --name $VERSION-ci-template
qm template $VMID
