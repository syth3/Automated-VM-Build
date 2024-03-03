packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "kali-latest-iso" {
  # VM Information
  vm_name = "OSCP-Kali"
  output_directory = "D:\\Virtual Machines\\OSCP\\OSCP-Kali"
  guest_os_type = "Debian 11.x 64-bit"

  # ISO
  iso_url = "https://cdimage.kali.org/current/kali-linux-2024.1-installer-amd64.iso"
  iso_checksum = "c150608cad5f8ec71608d0713d487a563d9b916a0199b1414b6ba09fce788ced"
  
  # Hardware
  network = "nat"
  cpus = 16
  memory = 32768
  disk_size = 262144
  disk_type_id = 0
  
  # Boot
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
  
  http_directory = "http-server"

  # SSH
  ssh_username = "kali"
  ssh_password = "kali"
  ssh_timeout = "1h"

  shutdown_command = "echo 'kali' | sudo -S shutdown -P now"
}

build {
  sources = ["sources.vmware-iso.kali-latest-iso"]
  provisioner "shell" {
    script = "scripts/setup.sh"
    execute_command = "echo 'kali' | sudo -S sh -c '{{ .Path }}'"
  }
}