resource "google_container_cluster" "autopilot_cluster" {
  name     = "autopilot-cluster"
  location = local.region

  enable_autopilot    = true
  deletion_protection = false # 実験用のため

  network    = data.terraform_remote_state.vpc.outputs.network_name
  subnetwork = data.terraform_remote_state.vpc.outputs.subnetwork_name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}
