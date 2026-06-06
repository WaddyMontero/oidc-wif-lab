locals {
  environments = {
    staging = {
      service_name        = "oidc-wif-lab-staging"
      runtime_account_id  = "cloudrun-runtime-staging"
      deployer_account_id = "gha-deployer-staging"
      pool_id             = "github-staging-pool"
      provider_id         = "github-staging-provider"
      branch_name         = var.staging_branch
    }
    production = {
      service_name        = "oidc-wif-lab-production"
      runtime_account_id  = "cloudrun-runtime-production"
      deployer_account_id = "gha-deployer-production"
      pool_id             = "github-production-pool"
      provider_id         = "github-production-provider"
      branch_name         = var.production_branch
    }
  }
}

data "google_project" "current" {
  project_id = var.project_id
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  location      = var.region
  repository_id = "oidc-wif-lab"

  # API enablement in GCP can take a short time to propagate. Making this
  # dependency explicit reduces a frustrating first-run race where Terraform
  # tries to create the repository before Artifact Registry is actually ready.
  depends_on = [google_project_service.required_apis]
}

module "iam" {
  for_each = local.environments
  source   = "./modules/iam"

  project_id          = var.project_id
  environment         = each.key
  runtime_account_id  = each.value.runtime_account_id
  deployer_account_id = each.value.deployer_account_id

  depends_on = [google_project_service.required_apis]
}

module "cloud_run" {
  for_each = local.environments
  source   = "./modules/cloud-run-service"

  service_name                  = each.value.service_name
  region                        = var.region
  image                         = var.bootstrap_image
  environment                   = each.key
  runtime_service_account_email = module.iam[each.key].runtime_service_account_email
  allow_unauthenticated         = var.allow_unauthenticated

  depends_on = [google_project_service.required_apis]
}

module "github_wif" {
  for_each = local.environments
  source   = "./modules/github-wif"

  environment                   = each.key
  pool_id                       = each.value.pool_id
  provider_id                   = each.value.provider_id
  github_owner                  = var.github_owner
  github_repo                   = var.github_repo
  branch_name                   = each.value.branch_name
  deployer_service_account_name = module.iam[each.key].deployer_service_account_name

  depends_on = [google_project_service.required_apis]
}
