# Workshop 4: Break/Fix Exercises

Review the intentionally bad examples under `labs/insecure-examples` and explain why each one is dangerous.

## Cases

1. WIF condition only checks `repository_owner`.
2. Deployer service account has `roles/editor`.
3. Deploy workflow runs on `pull_request`.
4. One deployer service account is shared across staging and production.
5. `id-token: write` is granted too broadly.
6. A third-party action is unpinned.
7. A guardrail script assumes `rg` exists everywhere.
8. A repository scanner treats `.terraform/` provider binaries as if they were authored source files.
9. GitHub Environment branch policy disagrees with the workflow trigger and the WIF provider condition.

## Exercise method

- Describe the trust assumption being made.
- Describe how an attacker could benefit.
- Describe the blast radius.
- Propose the smallest change that meaningfully reduces risk.
