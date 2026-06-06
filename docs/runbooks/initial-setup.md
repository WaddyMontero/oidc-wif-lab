# Initial Setup

1. Authenticate to GitHub and Google Cloud.
2. Set the active GCP project.
3. Create `infra/terraform.tfvars`.
4. Run `terraform init`, `terraform validate`, and `terraform plan`.
5. Apply Terraform.
6. Run `./scripts/configure-github-vars.sh`.
7. Confirm the `staging` and `production` GitHub Environments exist.
8. Add required reviewers to `production`.
