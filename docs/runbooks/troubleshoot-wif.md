# Troubleshoot WIF

If authentication fails:

1. Confirm the workflow job actually has `id-token: write`.
2. Confirm the job references the expected GitHub Environment.
3. Confirm the WIF provider resource name in GitHub variables matches Terraform output exactly.
4. Confirm the service account email in GitHub variables matches Terraform output exactly.
5. Use `OIDC Claims Debug` to inspect `repository`, `ref`, `environment`, and `workflow_ref`.
6. Compare those claims with the Terraform attribute condition.
7. Check that `roles/iam.workloadIdentityUser` is granted on the correct deployer service account.
