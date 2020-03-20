resource "google_compute_firewall" "jumpbox" {
  name        = "${var.env_name}-jumpbox"
  network     = "${var.network}"
  target_tags = ["${var.env_name}-jumpbox"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "jumpbox" {
  name         = "${var.env_name}-jumpbox"
  machine_type = "${var.jumpbox_machine_type}"
  zone         = "${var.zone}"
  tags         = ["${var.env_name}-jumpbox"]
  allow_stopping_for_update = true

  timeouts {
    create = "10m"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size  = 150
    }
  }

  network_interface {
    network = "${var.network}"
    subnetwork = "${var.subnetwork}"

    access_config {
      nat_ip = "${google_compute_address.jumpbox-ip.address}"
    }
  }

  metadata = {
    ssh-keys               = "${format("ubuntu:%s", tls_private_key.jumpbox.public_key_openssh)}"
    block-project-ssh-keys = "FALSE"
  }

  provisioner "remote-exec" {
    inline = [
      "ls -al",
    ]
  }
}

resource "google_compute_address" "jumpbox-ip" {
  name = "${var.env_name}-jumpbox-ip"
}

resource "tls_private_key" "jumpbox" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
variable "env_name" {}
variable "network" {}
variable "subnetwork" {}
variable "zone" {}
variable "jumpbox_machine_type" {
  default = "g1-small"
}
output "jumpbox-ip" {
  value = "${google_compute_address.jumpbox-ip.address}"
}

output "private_key" {
  value = "${tls_private_key.jumpbox.private_key_pem}"
}

output "public_key" {
  value = "${tls_private_key.jumpbox.public_key_openssh}"
}