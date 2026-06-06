resource "google_service_account" "runtime" {
  account_id   = var.runtime_account_id
  display_name = "Cloud Run runtime identity for ${var.environment}"
}

resource "google_service_account" "deployer" {
  account_id   = var.deployer_account_id
  display_name = "GitHub Actions deployer identity for ${var.environment}"
}

# Artifact Registry writer is broad enough for teaching and common in real life,
# but still far narrower than project-wide editor/owner. Students can later
# replace this with a tighter custom role as a stretch exercise.
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

# Cloud Run admin is also broader than ideal, but it cleanly enables deploys in
# a first-pass lab. The docs call out this tradeoff explicitly.
resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

# This permission is scoped to the runtime service account resource rather than
# the whole project. That distinction is important: the deployer can attach only
# the matching runtime identity, not arbitrary service accounts.
resource "google_service_account_iam_member" "runtime_service_account_user" {
  service_account_id = google_service_account.runtime.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.deployer.email}"
}
