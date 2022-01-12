variable "output_dir" {
  type    = string
  default = "output"
}

variable "output_name" {
  type    = string
  default = "debian.qcow2"
}

variable "source_iso" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/11.2.0/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso"
}

variable "source_checksum_url" {
  type    = string
  default = "file:https://cdimage.debian.org/cdimage/release/11.2.0/amd64/iso-cd/SHA256SUMS"
}

variable "ssh_username" {
  type    = string
  default = "nodi"
}

variable "ssh_password" {
  type    = string
  default = "nodi"
}

source "qemu" "debian" {
  iso_url      = "${var.source_iso}"
  iso_checksum = "${var.source_checksum_url}"

  cpus         = 4
  memory       = 2048
  disk_size    = 8000
  headless     = true
  accelerator  = "kvm"
  
  vnc_bind_address  = "0.0.0.0"

  http_directory = "http"
  http_port_min  = 9990
  http_port_max  = 9999

  host_port_min = 2222
  host_port_max = 2229

  ssh_username     = "${var.ssh_username}"
  ssh_password     = "${var.ssh_password}"
  ssh_wait_timeout = "1500s"

  shutdown_command = "echo '${var.ssh_password}'  | sudo -S /sbin/shutdown -hP now"

  # Builds a compact image
  disk_compression   = true
  disk_discard       = "unmap"
  skip_compaction    = false
  disk_detect_zeroes = "unmap"

  format           = "qcow2"
  output_directory = "${var.output_dir}"
  vm_name          = "${var.output_name}"

  boot_wait = "1s"
  boot_command = [
    "<down><tab>", 
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "language=en locale=en_US.UTF-8 ",
    "country=NL keymap=us ",
    "hostname=nodi domain=local ", 
    "<enter><wait>",
  ]
}

build {
  sources = ["source.qemu.debian"]

  provisioner "file" {
    destination = "/tmp/install-docker.sh"
    source      = "scripts/install-docker.sh"
  }

  provisioner "shell" {
    inline = [
      "sh -cx 'sudo bash /tmp/install-docker.sh ${var.ssh_username}'"
    ]
  }

  post-processor "manifest" {
    keep_input_artifact = true
  }
}
