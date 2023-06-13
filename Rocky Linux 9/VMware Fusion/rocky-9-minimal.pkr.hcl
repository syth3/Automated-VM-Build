packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "rocky-linux-9-minimal" {
  iso_url = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.2-x86_64-minimal.iso"
  iso_checksum = "file:https://download.rockylinux.org/pub/rocky/9/isos/x86_64/CHECKSUM"
  ssh_username = "root"
  ssh_password = "root"
  ssh_timeout = "1h"
  shutdown_command = "sudo -S shutdown -P now"
  network = "nat"
  cpus = 4
  memory = 8192
  disk_size = 102400
  output_directory = "/Users/jakebrown/Virtual Machines"  
  http_directory = "http-server"
  guest_os_type = "rhel9-64"
  vm_name = "packer-rocky-9-minimal"
  disk_type_id = 0
  boot_wait = "5s"
  boot_key_interval = "5ms"
  boot_command = ["<tab>",
                  " ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky-9-minimal-kickstart.cfg",
                  "<enter>"]
}

build {
  sources = ["sources.vmware-iso.rocky-linux-9-minimal"]
  # provisioner "shell" {
  #   script = "scripts/setup.sh"
  #   execute_command = "echo 'kali' | sudo -S sh -c '{{ .Path }}'"
  # }
}