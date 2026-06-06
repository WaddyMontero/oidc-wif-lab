# Workshop 3: IAM Blast Radius Review

## Goal

Practice asking "what could this workflow do if it were compromised?"

## Review prompts

Use the Terraform and workflow files to answer:

1. Can the CI workflow deploy anything?
2. Can the staging deploy workflow deploy production?
3. Can the deployer service account modify unrelated IAM by default?
4. Can the workflow create service account keys?
5. Can the runtime service account administer Cloud Run?

## Reasoning framework

- Start with the event trigger.
- Check job-level permissions.
- Check whether the job can mint an OIDC token.
- Check the WIF provider condition.
- Check which service account can be impersonated.
- Check which IAM roles that service account has.

That sequence keeps you from skipping straight to "the workflow has cloud access" without asking what kind and under which constraints.

## Stretch task

Replace one broad predefined role with a custom role and document exactly which permissions you chose and why.
