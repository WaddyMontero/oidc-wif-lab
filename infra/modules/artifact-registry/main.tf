resource "google_artifact_registry_repository" "this" {
  location      = var.location
  repository_id = var.repository_id
  description   = "Container repository for the OIDC WIF teaching lab."
  format        = "DOCKER"
}
