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
- branch provenance is part of the trust boundary, not just repository ownership
- broad roles such as `roles/editor` and `roles/owner` are intentionally avoided

Use `terraform.tfvars.example` as a starting point, then create a local `terraform.tfvars` file that stays out of version control.

## Operational Learnings

These are practical lessons from building and validating the lab itself.

- Do not assume CI runners have every local convenience tool. The guardrail script now falls back cleanly when `rg` is unavailable.
- Scope repo scans carefully. Generated directories like `.terraform/` can make a policy script fail for nonsense reasons if you scan them as if they were source code.
- API enablement is not always instantly usable. Artifact Registry required explicit dependency handling because Terraform could otherwise race API propagation on first apply.
- GitHub Environment branch policies must agree with both the workflow trigger and the WIF provider condition. If any one of those three disagrees, the deploy path fails even when the others are correct.
- If Terraform bootstraps a deployable service and GitHub Actions later owns rolling image updates, Terraform should ignore those deployment-managed fields rather than reverting the workload back to its placeholder image on the next plan.
