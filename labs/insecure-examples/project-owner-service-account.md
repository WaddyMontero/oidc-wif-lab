# Insecure Example: Overpowered Deployer

Bad idea:

Granting `roles/owner` or `roles/editor` to the deployer service account.

Why it is dangerous:

- a deployment workflow compromise becomes a project compromise
- unrelated services and IAM may be modified
- least privilege is lost
