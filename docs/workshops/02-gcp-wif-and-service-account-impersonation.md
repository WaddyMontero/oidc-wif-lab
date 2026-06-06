# Workshop 2: GCP WIF and Service Account Impersonation

## Goal

Understand the Google side of the trust exchange.

## Core components

- WIF pool: the top-level trust container
- WIF provider: the OIDC configuration and claim rules
- attribute mapping: how GitHub claims become Google attributes
- attribute condition: the CEL rule that decides whether the token is acceptable
- `roles/iam.workloadIdentityUser`: the permission that allows a federated principal to impersonate a service account

## Flow

```text
GitHub OIDC token
  -> STS / WIF validation
  -> service account impersonation
  -> short-lived Google access token
```

## Why impersonation matters

The workflow job does not become a project owner. It borrows a specific service account identity for a short time, and only if the token claims and IAM bindings line up. That keeps identity exchange explicit and reviewable.

## Why separate staging and production

Separate pools, providers, and deployer service accounts create smaller failure domains. If the staging workflow is compromised, the production trust path should still be a separate question rather than an automatic yes.

In this lab, the branch is part of that split too:

- staging trust expects `refs/heads/staging`
- production trust expects `refs/heads/main`

That is stricter than many repos, but it is coherent when you want integration activity and production-ready history to move on separate rails.

## Diagram

See [docs/diagrams/trust-flow.mmd](/Users/waddymontero/Documents/OIDC%20WIF%20Lab/docs/diagrams/trust-flow.mmd).

## Hands-on review

Inspect `infra/modules/github-wif/main.tf` and answer:

1. Which claims are mapped?
2. Which claims are enforced?
3. What would get broader if the condition checked only `repository_owner`?
