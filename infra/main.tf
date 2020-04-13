# vim:foldmethod=indent

provider "google" {
  version = "3.8.0"
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

variable "ssh_keys" {
  type        = string
  description = "The ssh username and key in the format `username:ssh-key`."
}

variable "project_id" {
  type        = string
  description = "The name of the google cloud project you're deploying to."
}

variable "region" {
  type        = string
  description = "The region you want your infrastructure to deploy to."
}

variable "zone" {
  type        = string
  description = "The zone, within the region, that you want to deploy to."
}

output "shortnr_static_ip" {
  value       = google_compute_address.shortnr.address
  description = "The public static IP address used by the Shortnr instance."
}

data "google_compute_image" "debian_image" {
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_address" "shortnr" {
  name         = "shortnr-address"
  network_tier = "STANDARD"
}

resource "google_compute_instance" "shortnr" {
  name         = "shortnr-instance"
  machine_type = "f1-micro"

  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip       = google_compute_address.shortnr.address
      network_tier = "STANDARD"
    }
  }

  metadata = {
    ssh-keys = var.ssh_keys
  }
}

resource "google_compute_firewall" "http_server" {
  name    = "http-server"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "docker_machine" {
  name    = "docker-machine"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2376"]
  }
}
