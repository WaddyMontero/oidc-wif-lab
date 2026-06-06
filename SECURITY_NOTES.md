# Security Notes

This file explains the trust boundaries in the lab in plain language.

## Authentication vs authorization

- Authentication answers: who are you?
- Authorization answers: what are you allowed to do?

In this lab, GitHub authenticates a workflow job by issuing an OIDC token. Google Cloud then uses Workload Identity Federation plus IAM to decide whether that authenticated workload is allowed to impersonate a deployer service account and act in the project.

## OIDC token vs `GITHUB_TOKEN`

- The OIDC token is an identity assertion. It says things like which repository, branch, environment, and workflow produced the job.
- The `GITHUB_TOKEN` is a GitHub API token scoped to repository operations in GitHub.

Those are different trust planes. An OIDC token does not automatically grant GitHub repo write access, and a `GITHUB_TOKEN` does not automatically grant Google Cloud access.

## Issuer, subject, audience, and claims

- `iss`: who issued the token. In this lab, GitHub is the issuer.
- `sub`: the subject that GitHub says this workload is.
- `aud`: the intended audience for the token.
- claims: the metadata carried inside the signed token, such as repository, branch, workflow, and environment.

## WIF pool vs WIF provider

- The pool is the trust container.
- The provider is the specific OIDC configuration inside that pool.

We split staging and production into separate pools and providers so students can see that a trust boundary can be an explicit design choice rather than an accident.

## Attribute mapping vs attribute condition

- Attribute mapping copies selected token claims into Google attributes.
- Attribute condition is the gate that checks those attributes.

Mapping without a narrow condition is dangerous because it gathers useful data but does not actually constrain who can pass.

## Service account as principal vs service account as resource

- As a principal, a service account is an identity that can act.
- As a resource, a service account can have IAM bindings that control who may impersonate or attach it.

That distinction matters twice in this lab:

- GitHub Actions impersonates the deployer service account.
- The deployer service account is allowed to attach the runtime service account to Cloud Run.

## Who can impersonate the deployer service account?

Only the matching GitHub environment and workflow path should satisfy the WIF provider condition, and only the matching WIF pool has `roles/iam.workloadIdentityUser` on the matching deployer service account.

## What can the deployer service account do?

Baseline lab permissions:

- `roles/artifactregistry.writer`
- `roles/run.admin`
- `roles/iam.serviceAccountUser` on the matching runtime service account

This is intentionally a teaching baseline rather than a perfect least-privilege endpoint. The blast radius is much smaller than `roles/editor`, but it is still broader than a custom role tuned to a single service.

## Why service account keys are avoided

Long-lived keys are difficult to rotate, easy to leak, and often get copied into places they do not belong. WIF plus impersonation replaces a standing secret with a short-lived, claim-validated trust exchange.

## Why production is manual

Manual production deployment creates an explicit human checkpoint. That reduces the chance that an ordinary merge, bad automation, or compromised lower-trust event path turns into an immediate production release.

## Why `pull_request` deploys are dangerous

Pull request events are higher-risk because they are closer to unreviewed or partially reviewed code paths. If deploy permissions are attached there, an attacker may get a shorter path from repository compromise to cloud actions.

## Why broad WIF conditions are dangerous

A condition like `repository_owner == "example-org"` trusts every repository in that owner scope. A condition like `principalSet://.../POOL/*` trusts every workload admitted to the pool. Both dramatically enlarge the set of workloads that can impersonate the deployer account.

## Why SHA pinning is recommended

This lab uses stable major tags for common actions to keep the YAML readable for students. In a production repository, pinning actions to full commit SHAs reduces supply-chain drift and makes review more exact.

## Identity table

| Identity | Authenticated by | Authorized by | Can do | Cannot do |
| --- | --- | --- | --- | --- |
| GitHub Actions CI job | GitHub Actions runtime | GitHub workflow permissions | run tests, build locally, validate Terraform | mint cloud credentials in this lab |
| GitHub Actions staging deploy job | GitHub OIDC issuer plus WIF validation | WIF provider condition and IAM on staging deployer SA | push image and deploy staging | deploy production if trust is split correctly |
| GitHub Actions production deploy job | GitHub OIDC issuer plus WIF validation | WIF provider condition and IAM on production deployer SA | push image and deploy production when manually approved | bypass environment protections |
| Staging deployer service account | Google IAM after impersonation | project and service-account IAM bindings | deploy staging workload and push images | act as Owner or Editor |
| Production deployer service account | Google IAM after impersonation | project and service-account IAM bindings | deploy production workload and push images | automatically trust staging workflow |
| Runtime service account | Cloud Run runtime identity | attached to Cloud Run service | represent the running app | administer deployment pipeline |
