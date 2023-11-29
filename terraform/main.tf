##--Connects Cloud Cloud Provider and other Terraform drivers/modules
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }
}

##--Defines Local Variables
variable "yc_token" { type=string }

locals {
  ## generates auth-token (with 12h lifespan)
  ## $ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token
  #
  iam_token        = "${var.yc_token}"
  cloud_id         = "b1g0u201bri5ljle0qi2"
  folder_id        = "b1gqi8ai4isl93o0qkuj"
  access_zone      = "ru-central1-b"
  netw_name        = "acme-net"
  net_id           = "enpjul7bs1mq29s7m5gf"
  net_sub_name     = "acme-net-sub2"
  net_sub_id       = "e2lbvjotvmelh1nslcrr"
  vm_default_login = "ubuntu"
  ssh_keys_dir     = "/home/devops/.ssh"
  ssh_pubkey_path  = "/home/devops/.ssh/id_ed25519.pub"
  ssh_privkey_path = "/home/devops/.ssh/id_ed25519"
  #
  vm_img_id        = "fd8qe9b3l76lapdh08q6"  # https://cloud.yandex.com/en-ru/marketplace/products/yc/ubuntu-18-04-lts
  vm_img_desc      = "Ubuntu 18.04 LTS"
  vm1_name         = "u181"
  vm1_hostname     = "u181"
  vm1_ipv4_local   = "10.0.20.10"
  vm1_disk0size    = 8
  vm2_name         = "u182"
  vm2_hostname     = "u182"
  vm2_ipv4_local   = "10.0.20.11"
  vm2_disk0size    = 8
}

##--Connects to Cloud with Cloud ids
provider "yandex" {
  token     = local.iam_token
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.access_zone
}

##----------------------------------------------------------------------------------------
##--Creates VM1 (Ubuntu 18.04, x2 vCPU, x2 GB RAM, x8 GB HDD) -- PostgreSQL Server
resource "yandex_compute_instance" "vm1" {
  name        = local.vm1_name
  hostname    = local.vm1_hostname
  platform_id = "standard-v2"
  zone        = local.access_zone

  ## Sets CPU, CPU fraction, Memory values
  resources {
    cores         = 2
    core_fraction = 5
    memory        = 2
  }

  ## Sets VM interruptible by Cloud technical tasks (makes VM 50% cheaper)
  scheduling_policy {
    preemptible = true
  }

  ## Sets Boot disk configuration
  boot_disk {
    initialize_params {
      image_id    = local.vm_img_id
      description = local.vm_img_desc
      type        = "network-hdd"
      size        = local.vm1_disk0size
    }
  }

  ## Sets Network interface configuration
  network_interface {
    #subnet_id  = yandex_vpc_subnet.subnet1.id
    subnet_id   = local.net_sub_id
    ip_address  = local.vm1_ipv4_local
    nat         = true
  }

  ## Sets OS User authentication parameters
  metadata = {
    serial-port-enable = 0
    ssh-keys = "ubuntu:${file("${local.ssh_pubkey_path}")}"
  }

  ## Copies files #1
  ## Copies ssh-key directory from local host to remote VM (for further "devops" user configuration)
  provisioner "file" {
    source      = local.ssh_keys_dir
    destination = "/tmp"

    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "3m"
    }
  }

  ## Copies files #1
  ## Copies shell scripts and configuration files from local host to remote VM
  provisioner "file" {
    source      = "scripts/vm1"
    destination = "/home/ubuntu/scripts/"

    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
  }

  ## Executes master shell-script on remote VM after VM becomes available online
  ## *master script executes other scripts
  provisioner "remote-exec" {
    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
    ##..shell command execution block (1 command executes per 1 ssh connection)
    inline = [
      "chmod +x /home/ubuntu/scripts/step00-main.sh",
      "/home/ubuntu/scripts/step00-main.sh"
    ]

  } ## << "provisioner remote-exec"

}


##----------------------------------------------------------------------------------------
##--Creates VM2 (Ubuntu 22.04, x2 vCPU, x2 GB RAM, x8 GB HDD) -- PostgreSQL Client App
resource "yandex_compute_instance" "vm2" {
  name        = local.vm2_name
  hostname    = local.vm2_hostname
  platform_id = "standard-v2"
  zone        = local.access_zone

  ##..vm2 instance will be created after vm1 is created
  ##  *warnining: "yandex_compute_instance.vm1" :: Quoted references are deprecated :: references are expected literally
  depends_on = [
    yandex_compute_instance.vm1,
  ]

  resources {
    cores         = 2
    core_fraction = 5
    memory        = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id    = local.vm_img_id
      description = local.vm_img_desc
      type        = "network-hdd"
      size        = local.vm2_disk0size
    }
  }

  network_interface {
    subnet_id   = local.net_sub_id
    ip_address  = local.vm2_ipv4_local
    nat         = true
  }

  metadata = {
    serial-port-enable = 0
    ssh-keys = "ubuntu:${file("${local.ssh_pubkey_path}")}"
  }

  provisioner "file" {
    source      = local.ssh_keys_dir
    destination = "/tmp"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "3m"
    }
  }

  provisioner "file" {
    source      = "scripts/vm2"
    destination = "/home/ubuntu/scripts/"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
    inline = [
      "chmod +x /home/ubuntu/scripts/step00-main.sh",
      "/home/ubuntu/scripts/step00-main.sh"
    ]

  } ## << "provisioner remote-exec"

}
