# Infrastructure

This Terraform configuration builds the GCP side of the lab:

- required APIs
- one Artifact Registry repository
- one staging Cloud Run service
- one production Cloud Run service
- separate runtime and deployer service accounts for each environment
- separate Workload Identity Federation pools and providers for staging and production

The design is intentionally educational:

- runtime identity is split from deployment identity
- staging and production trust boundaries are split
- the WIF provider condition is narrow and readable
- broad roles such as `roles/editor` and `roles/owner` are intentionally avoided

Use `terraform.tfvars.example` as a starting point, then create a local `terraform.tfvars` file that stays out of version control.
