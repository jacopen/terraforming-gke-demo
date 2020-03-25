resource "google_container_cluster" "cluster" {
  name               = "${var.env_name}-${var.cluster_name}"
  location           = var.location

  network            = var.network
  subnetwork         = var.subnetwork

  min_master_version = var.min_master_version
  node_version       = var.node_version
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "node_pool" {
  name               = "${var.env_name}-${var.cluster_name}"
  cluster            = google_container_cluster.cluster.name
  location           = var.location
  node_count         = var.node_count

  node_config {
    machine_type   = var.machine_type
  }
}

variable "network" {}
variable "subnetwork" {}
variable "location" {}

variable "zone" {}
variable "node_count"{
  default = "1"
}
variable "machine_type" {
  default = "n1-standard-1"
}
variable "min_master_version" {
  default = "1.15.9-gke.24"
}
variable "node_version" {
  default = "1.15.9-gke.24"
}
variable "env_name" {}
variable "cluster_name" {}
