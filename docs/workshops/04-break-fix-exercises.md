# Workshop 4: Break/Fix Exercises

Review the intentionally bad examples under `labs/insecure-examples` and explain why each one is dangerous.

## Cases

1. WIF condition only checks `repository_owner`.
2. Deployer service account has `roles/editor`.
3. Deploy workflow runs on `pull_request`.
4. One deployer service account is shared across staging and production.
5. `id-token: write` is granted too broadly.
6. A third-party action is unpinned.

## Exercise method

- Describe the trust assumption being made.
- Describe how an attacker could benefit.
- Describe the blast radius.
- Propose the smallest change that meaningfully reduces risk.
