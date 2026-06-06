output "project_id" {
  value = var.project_id
}

output "project_number" {
  value = data.google_project.current.number
}

output "region" {
  value = var.region
}

output "github_owner" {
  value = var.github_owner
}

output "github_repo" {
  value = var.github_repo
}

output "staging_branch" {
  value = var.staging_branch
}

output "production_branch" {
  value = var.production_branch
}

output "artifact_registry_repository" {
  value = module.artifact_registry.repository_id
}

output "staging_cloud_run_service" {
  value = module.cloud_run["staging"].service_name
}

output "production_cloud_run_service" {
  value = module.cloud_run["production"].service_name
}

output "staging_deployer_service_account" {
  value = module.iam["staging"].deployer_service_account_email
}

output "production_deployer_service_account" {
  value = module.iam["production"].deployer_service_account_email
}

output "staging_workload_identity_provider" {
  value = module.github_wif["staging"].provider_name
}

output "production_workload_identity_provider" {
  value = module.github_wif["production"].provider_name
}

output "github_variable_commands_staging" {
  value = [
    "gh variable set GCP_PROJECT_ID --env staging --body \"${var.project_id}\"",
    "gh variable set GCP_REGION --env staging --body \"${var.region}\"",
    "gh variable set GAR_REPOSITORY --env staging --body \"${module.artifact_registry.repository_id}\"",
    "gh variable set CLOUD_RUN_SERVICE --env staging --body \"${module.cloud_run["staging"].service_name}\"",
    "gh variable set WIF_PROVIDER --env staging --body \"${module.github_wif["staging"].provider_name}\"",
    "gh variable set DEPLOYER_SERVICE_ACCOUNT --env staging --body \"${module.iam["staging"].deployer_service_account_email}\"",
  ]
}

output "github_variable_commands_production" {
  value = [
    "gh variable set GCP_PROJECT_ID --env production --body \"${var.project_id}\"",
    "gh variable set GCP_REGION --env production --body \"${var.region}\"",
    "gh variable set GAR_REPOSITORY --env production --body \"${module.artifact_registry.repository_id}\"",
    "gh variable set CLOUD_RUN_SERVICE --env production --body \"${module.cloud_run["production"].service_name}\"",
    "gh variable set WIF_PROVIDER --env production --body \"${module.github_wif["production"].provider_name}\"",
    "gh variable set DEPLOYER_SERVICE_ACCOUNT --env production --body \"${module.iam["production"].deployer_service_account_email}\"",
  ]
}
