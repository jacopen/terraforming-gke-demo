resource "google_compute_address" "cp_ingress_ip" {
  name = "${var.env_name}-cp-ingress-ip"
}

resource "google_dns_managed_zone" "root" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.root_domain}."
  description = "DNS zone for the root domain"
}

resource "google_dns_managed_zone" "controlplane" {
  name        = "${var.env_name}-cp-zone"
  dns_name    = "cp.${var.root_domain}."
  description = "DNS zone for the controlplane environment"
}

resource "google_dns_record_set" "name_servers" {
  name  = "cp.${google_dns_managed_zone.root.dns_name}"
  type  = "NS"
  ttl   = 60

  managed_zone = google_dns_managed_zone.root.name

  rrdatas = google_dns_managed_zone.controlplane.name_servers
}

resource "google_dns_record_set" "cp_ingress" {
  name  = "*.${google_dns_managed_zone.controlplane.dns_name}"
  type  = "A"
  ttl   = 60

  managed_zone = google_dns_managed_zone.controlplane.name

  rrdatas = [google_compute_address.cp_ingress_ip.address]
}

resource "google_dns_record_set" "cp_jumpbox" {
  name  = "jumpbox.${google_dns_managed_zone.controlplane.dns_name}"
  type  = "A"
  ttl   = 60

  managed_zone = google_dns_managed_zone.controlplane.name

  rrdatas = [module.jumpbox.jumpbox_ip]
}