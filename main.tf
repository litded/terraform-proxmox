terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}

provider "proxmox" {
    pm_api_url = "https://<ip>:8006/api2/json"
    pm_user = "terraform-prov@pam"
    pm_password = var.pm_password
    pm_tls_insecure = "true"
}

/*
!!! Взять пример из resourse-template !!!

Убрать count или задать нужное число копий,
но тогда в name и ipconfig0 добавьте переменную ${count.index + 1} 

Поменять имя "pveX-tf-vm-XX"
Поменять name
Задать ip в ipconfig0

*/


# >> pve vm: <<


