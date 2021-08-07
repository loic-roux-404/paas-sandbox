
variable "vm_name" {}
variable "box_name" {}
variable "box_version" {
  default = "0.0.0"
}
variable "box_changelog" {}
variable "description" {}

variable "distro_version" {
    default = "0.0"
}
// variable "iso_url" {}
variable "iso_checksum" {
    default = "{{ env `ISO_SHA256` }}"
}
variable "playbook" {
    default = "playbook"
}
variable "sub_playbook" {
    default = "site.yml"
}
variable "inventory" {}
// variable "playbook_file" {}
// variable "inventory_directory" {}

locals {
    cloud_token = "{{ env `VAGRANT_CLOUD_TOKEN` }}"
    output_dir = "${var.vm_name}.build"
    exports_dir = "${var.vm_name}.build/exports"
    iso_url = "https=//cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-${var.distro_version}.0-amd64-netinst.iso"
    playbook_file = "./ansible/${var.playbook}/${var.sub_playbook}"
    inventory_directory = "../ansible/${var.playbook}/inventories/${var.inventory}"
}

# enum builder sources
source "qemu" "vg-libvirt"{
  boot_command = [
    "<esc><wait>",
    "install <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/buster-preseed.cfg <wait>",
    "auto <wait>",
    "locale=en_US.UTF-8 <wait>",
    "netcfg/get_hostname={{ .Name }} <wait>",
    "netcfg/get_domain=vagrantup.com <wait>",
    "debconf/frontend=noninteractive <wait>",
    "console-setup/ask_detect=false <wait>",
    "kbd-chooser/method=us <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "keyboard-configuration/xkb-keymap=us <wait>",
    "net.ifnames=0 <wait>",
    "<enter><wait>"
  ]
  disk_size = 20280
  memory = 1024
  cpus = 2
  disk_interface = "virtio"
  headless = true
  http_directory = "http"
  iso_checksum = var.iso_checksum
  iso_checksum_type = "sha256"
  iso_url = local.iso_url
  accelerator = "hvf"
  ssh_password = "vagrant"
  ssh_username =" vagrant"
  ssh_port = 22
  ssh_wait_timeout = "10000s"
  shutdown_command = "echo 'vagrant' | sudo /sbin/halt -p"
  output_directory = local.output_dir
  vm_name = var.vm_name
  format = "raw"
}

source "qemu" "vg-vbox" {
    boot_command = [
      "<up><wait><tab> text ks=http=//{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg PACKER_USER=vagrant PACKER_PASSWORD=vagrant PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}<enter>"
    ]
    headless = true
    checksum = var.iso_checksum
    checksum_type = "sha256"
    type = "virtualbox-ovf"
    format = "ovf"
    source_path = "${vm_name}.ovf"
    guest_additions_mode = "disable"
    virtualbox_version_file = ""
    communicator = "none"
    output_directory = local.output_dir
    shutdown_command = ""
    shutdown_timeout = "1s"
    vm_name = var.vm_name
}

# Dispatch builders > provision > post-processors
build {
    sources = [
        "source.qemu.vg-libvirt",
        "source.virtualbox.vg-vbox"
    ]

    provisioner "file" {
        source = "res"
        destination = "/tmp/res"
        except = ["virtualbox-ovf"]
    }

    provisioner "shell" {
      pause_before = "5s"
      execute_command = "echo 'vagrant'| {{ .Vars }} sudo --preserve-env --stdin sh '{{ .Path }}'"
      environment_vars = [
        "VAGRANT_BUILDER_FS = /",
        "DEBUG = {{ env `PACKER_LOG` }}"
      ]
      scripts = [
        "../helpers/vagrant-setup",
        "scripts/customize.sh",
        "scripts/networking.sh"
      ]
      except = ["virtualbox-ovf"]
    }

    provisioner "ansible" {
        playbook_file = local.playbook_file
        inventory_directory =  local.inventory_directory
        except = ["virtualbox-ovf"]
    }

    provisioner "shell" {
      pause_before = "1s"
        execute_command = "echo 'vagrant' | {{ .Vars }} sudo --preserve-env --stdin sh '{{ .Path }}'"
        scripts = [
            "scripts/cleanup.sh",
            "scripts/minimize.sh"
        ]
        except = ["virtualbox-ovf"]
    }

    post-processor "shell-local" {
        environment_vars = [
          "VM_NAME=${var.vm_name}",
          "OUTPUT=${var.output_dir}",
          "WORK_PATH=./"
        ]
        script = "scripts/conversions.sh"
        except = ["virtualbox-ovf"]
    }

    post-processor "shell-local" {
        inline = [
          "make ${var.vm_name}.libvirt.box"
        ]
        except = ["virtualbox-ovf"]
    }

    post-processor "artifice" {
        files = [
          "${var.exports_dir}/${var.vm_name}.libvirt.box"
        ]
        except = ["virtualbox-ovf"]
    }

    post-processor "vagrant" {
        output = "${var.exports_dir}/${var.vm_name}.{{ .Provider }}.box"
        keep_input_artifact = true
        only = ["virtualbox-ovf"]
    }
          
    post-processor "vagrant-cloud" {
        box_tag = "loic-roux-404/${box_name}"
        access_token = local.cloud_token
        version = var.box_version
    }
}
