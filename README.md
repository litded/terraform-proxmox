# Terraform Proxmox


**Подготовка proxmox:**

Create the user
```
pveum user add terraform-prov@pve --password $PASSWORD
```
Assign the user the correct role
```
pveum aclmod / -user terraform-prov@pve -role Administrator
```
Navigate to the ISO directory for Proxmox
```
$ cd /var/lib/vz/templates/isos
```
Source the image
```
$ wget http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2
```
Create the instance
```
qm create 9000 -name debian-cloudinit -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1
```
Import the OpenStack disk image to Proxmox storage
```
qm importdisk 9000 debian-10-openstack-amd64.qcow2 local-lvm
```
Attach the disk to the virtual machine
```
qm set 9000 -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-9000-disk-0
```
Add a serial output
```
qm set 9000 -serial0 socket
```
Set the bootdisk to the imported Openstack disk
```
qm set 9000 -boot c -bootdisk virtio0
```
Enable the Qemu agent
```
qm set 9000 -agent 1
```
Allow hotplugging of network, USB and disks
```
qm set 9000 -hotplug disk,network,usb
```
Add a single vCPU (for now)
```
qm set 9000 -vcpus 1
```
Add a video output
```
qm set 9000 -vga qxl
```
Set a second hard drive, using the inbuilt cloudinit drive
```
qm set 9000 -ide2 local-lvm:cloudinit
```
Resize the primary boot disk (otherwise it will be around 2G by default)

This step adds another 8G of disk space, but change this as you need to
```
qm resize 9000 virtio0 +8G
```
Convert the VM to the template
```
qm template 9000
```


**Terraform add vm:**

Взять пример из resourse-template

Убрать count или задать нужное число копий, но тогда в name и ipconfig0 добавьте переменную ${count.index + 1} 

Поменять имя "pveX-tf-vm-XX"

Поменять name

Задать ip в ipconfig0


```
$ export TF_VAR_pm_password="passwd"
$ terraform init
$ terraform plan 
$ terraform apply
```


