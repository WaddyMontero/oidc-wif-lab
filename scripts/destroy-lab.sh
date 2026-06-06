#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../infra"

echo "This will remove the OIDC WIF lab resources from GCP."
echo "That includes:"
echo "- Artifact Registry repository"
echo "- Cloud Run services"
echo "- runtime service accounts"
echo "- deployer service accounts"
echo "- Workload Identity Federation pools and providers"
echo
echo "Review the plan below carefully."
terraform destroy "$@"
