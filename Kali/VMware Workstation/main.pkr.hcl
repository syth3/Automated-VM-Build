packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "kali-latest-iso" {
  iso_url = "https://cdimage.kali.org/kali-2023.1/kali-linux-2023.1-installer-amd64.iso"
  iso_checksum = "file:https://cdimage.kali.org/kali-2023.1/SHA256SUMS"
  ssh_username = "kali"
  ssh_password = "kali"
  ssh_timeout = "1h"
  shutdown_command = "echo 'kali' | sudo -S shutdown -P now"
  network = "nat"
  cpus = 1
  cores = 4
  memory = 8192
  disk_size = 102400
  output_directory = "D:\\Virtual Machines\\Packer Builds\\packer-kali"
  http_directory = "http-server"
  guest_os_type = "Debian 11.x 64-bit"
  vm_name = "packer-kali"
  disk_type_id = 0
  boot_wait = "5s"
  boot_key_interval = "5ms"
  boot_command = ["<wait><wait><wait><esc><wait><wait><wait>",
                  "/install.amd/vmlinuz ", 
                  "net.ifnames=0 ", 
                  "auto=true ", 
                  "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", 
                  "priority=critical ", 
                  "vga=788 ", 
                  "initrd=/install.amd/gtk/initrd.gz ", 
                  "--- quiet", 
                  "<wait><enter><wait>"]
}

build {
  sources = ["sources.vmware-iso.kali-latest-iso"]
  provisioner "shell" {
    script = "scripts/setup.sh"
    execute_command = "echo 'kali' | sudo -S sh -c '{{ .Path }}'"
  }
}