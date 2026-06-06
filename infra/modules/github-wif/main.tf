resource "google_iam_workload_identity_pool" "this" {
  workload_identity_pool_id = var.pool_id
  display_name              = "GitHub ${var.environment} pool"
  description               = "Trust boundary for GitHub Actions deployments into ${var.environment}."
}

resource "google_iam_workload_identity_pool_provider" "this" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "GitHub ${var.environment} provider"
  description                        = "OIDC provider for GitHub Actions ${var.environment} deployments."

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.repository_id"    = "assertion.repository_id"
    "attribute.ref"              = "assertion.ref"
    "attribute.ref_type"         = "assertion.ref_type"
    "attribute.environment"      = "assertion.environment"
    "attribute.workflow"         = "assertion.workflow"
    "attribute.workflow_ref"     = "assertion.workflow_ref"
    "attribute.actor"            = "assertion.actor"
    "attribute.event_name"       = "assertion.event_name"
  }

  attribute_condition = <<-EOT
    attribute.repository_owner == "${var.github_owner}" &&
    attribute.repository == "${var.github_owner}/${var.github_repo}" &&
    attribute.ref == "refs/heads/${var.branch_name}" &&
    attribute.environment == "${var.environment}" &&
    attribute.workflow_ref == "${var.github_owner}/${var.github_repo}/.github/workflows/deploy-${var.environment}.yml@refs/heads/${var.branch_name}"
  EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = var.deployer_service_account_name
  role               = "roles/iam.workloadIdentityUser"

  # We bind to the specific subject-set path for this pool and repository
  # attribute, rather than a wildcard over the entire pool, so the trust edge is
  # much narrower and easier for students to reason about.
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}
