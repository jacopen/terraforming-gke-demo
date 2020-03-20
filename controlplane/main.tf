terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jacopen"

    workspaces {
      name = "controlplane"
    }
  }
}

provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.credentials}"
}

module "gke" {
  source = "../modules/gke"

  env_name     = "${var.env_name}"
  cluster_name = "${var.cluster_name}"
  network      = "${var.network}"
  subnetwork   = "${var.subnetwork}"
  zone         = "${var.zone}"
  location     = "${var.region}"
}

module "jumpbox" {
  source = "../modules/jumpbox"

  env_name   = "${var.env_name}"
  network    = "${var.network}"
  subnetwork = "${var.subnetwork}"
  zone       = "${var.zone}"
}

variable "project" {
}

variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-a"
}

variable "env_name" {
}

variable "cluster_name" {
}

variable "network" {
}

variable "subnetwork" {
}

variable "credentials" {
}

