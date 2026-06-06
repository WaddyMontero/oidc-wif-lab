# Troubleshoot WIF

If authentication fails:

1. Confirm the workflow job actually has `id-token: write`.
2. Confirm the job references the expected GitHub Environment.
3. Confirm the WIF provider resource name in GitHub variables matches Terraform output exactly.
4. Confirm the service account email in GitHub variables matches Terraform output exactly.
5. Use `OIDC Claims Debug` to inspect `repository`, `ref`, `environment`, and `workflow_ref`.
6. Compare those claims with the Terraform attribute condition.
7. Check that `roles/iam.workloadIdentityUser` is granted on the correct deployer service account.

## Operational gotchas from this lab

1. If a deploy job is rejected before any real runner steps appear, inspect GitHub Environment protection rules as well as workflow logs.
2. If a policy or guardrail script behaves differently in CI than locally, check for missing tools first. Local success does not prove runner parity.
3. If Terraform enables an API and then immediately fails to create a resource behind it, retry after propagation or add a clearer dependency edge so the first run is less racy.
4. If your staging workflow, environment branch policy, and WIF branch condition do not all point to the same branch, authentication may look broken even though the real issue is trust-model misalignment.
