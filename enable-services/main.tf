resource "google_project_service" "container" {
  for_each = toset([
    # GKE
    "container.googleapis.com",
    "containerregistry.googleapis.com",
  ])

  project = local.project
  service = each.key
}
