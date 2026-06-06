#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../infra"

terraform output -json | python3 - <<'PY'
import json
import sys

data = json.load(sys.stdin)

project_id = data["project_id"]["value"]
region = data["region"]["value"]
repo = data["artifact_registry_repository"]["value"]
github_owner = data["github_owner"]["value"]
github_repo = data["github_repo"]["value"]

print("Staging trust relationship")
print(f"GitHub repo: {github_owner}/{github_repo}")
print("GitHub environment: staging")
print("Expected branch: refs/heads/main")
print("Expected workflow: .github/workflows/deploy-staging.yml@refs/heads/main")
print(f"WIF provider: {data['staging_workload_identity_provider']['value']}")
print(f"Deployer service account: {data['staging_deployer_service_account']['value']}")
print(f"Cloud Run service: {data['staging_cloud_run_service']['value']}")
print(f"Artifact Registry repo: {region}-docker.pkg.dev/{project_id}/{repo}")
print()
print("Production trust relationship")
print(f"GitHub repo: {github_owner}/{github_repo}")
print("GitHub environment: production")
print("Expected branch: refs/heads/main")
print("Expected workflow: .github/workflows/deploy-production.yml@refs/heads/main")
print(f"WIF provider: {data['production_workload_identity_provider']['value']}")
print(f"Deployer service account: {data['production_deployer_service_account']['value']}")
print(f"Cloud Run service: {data['production_cloud_run_service']['value']}")
print(f"Artifact Registry repo: {region}-docker.pkg.dev/{project_id}/{repo}")
PY
