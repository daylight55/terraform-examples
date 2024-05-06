resource "google_container_cluster" "autopilot_cluster" {
  name     = "autopilot-cluster"
  location = "us-central1"

  enable_autopilot = true

  network    = data.terraform_remote_state.vpc.outputs.network_name
  subnetwork = data.terraform_remote_state.vpc.outputs.subnetwork_name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  depends_on = [
    google_project_service.container
  ]
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}
