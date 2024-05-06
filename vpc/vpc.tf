resource "google_compute_network" "vpc" {
  name                    = "daylight-labo"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnetwork" {
  name          = "gke-subnetwork"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.2.0.0/16"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.3.0.0/18"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.3.64.0/18"
  }
}

output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.gke_subnetwork.name
}
