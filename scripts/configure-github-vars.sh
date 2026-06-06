#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../infra"

PROJECT_ID="$(terraform output -raw project_id)"
REGION="$(terraform output -raw region)"
REPOSITORY="$(terraform output -raw artifact_registry_repository)"
GITHUB_OWNER="$(terraform output -raw github_owner)"
GITHUB_REPO="$(terraform output -raw github_repo)"
TARGET_REPO="${GITHUB_OWNER}/${GITHUB_REPO}"
STAGING_SERVICE="$(terraform output -raw staging_cloud_run_service)"
PRODUCTION_SERVICE="$(terraform output -raw production_cloud_run_service)"
STAGING_PROVIDER="$(terraform output -raw staging_workload_identity_provider)"
PRODUCTION_PROVIDER="$(terraform output -raw production_workload_identity_provider)"
STAGING_SA="$(terraform output -raw staging_deployer_service_account)"
PRODUCTION_SA="$(terraform output -raw production_deployer_service_account)"

configure_env() {
  local env_name="$1"
  local service="$2"
  local provider="$3"
  local deployer_sa="$4"

  gh variable set GCP_PROJECT_ID --repo "$TARGET_REPO" --env "$env_name" --body "$PROJECT_ID"
  gh variable set GCP_REGION --repo "$TARGET_REPO" --env "$env_name" --body "$REGION"
  gh variable set GAR_REPOSITORY --repo "$TARGET_REPO" --env "$env_name" --body "$REPOSITORY"
  gh variable set CLOUD_RUN_SERVICE --repo "$TARGET_REPO" --env "$env_name" --body "$service"
  gh variable set WIF_PROVIDER --repo "$TARGET_REPO" --env "$env_name" --body "$provider"
  gh variable set DEPLOYER_SERVICE_ACCOUNT --repo "$TARGET_REPO" --env "$env_name" --body "$deployer_sa"
}

configure_env "staging" "$STAGING_SERVICE" "$STAGING_PROVIDER" "$STAGING_SA"
configure_env "production" "$PRODUCTION_SERVICE" "$PRODUCTION_PROVIDER" "$PRODUCTION_SA"

echo "Configured GitHub environment variables for staging and production."
