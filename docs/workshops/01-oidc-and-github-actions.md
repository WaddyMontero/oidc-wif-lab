# Workshop 1: OIDC and GitHub Actions

## Goal

Understand what GitHub is actually proving when it issues an OIDC token to a workflow job.

## What GitHub proves

GitHub proves facts about the workflow execution context, not about your intent. For example:

- which repository the job belongs to
- which ref triggered it
- which workflow file is running
- which GitHub Environment is attached
- which actor initiated the run

That matters because cloud trust should be attached to those facts, not to wishful assumptions like "this is probably our deploy workflow."

## What claims are

Claims are structured fields inside the JWT payload. They are signed by the issuer, so the cloud side can verify integrity before trusting them.

Useful claims in this lab:

- `iss`
- `aud`
- `sub`
- `repository`
- `repository_owner`
- `ref`
- `environment`
- `workflow_ref`

## What `sub`, `aud`, and `iss` mean

- `iss`: who issued the token
- `sub`: who the token is about
- `aud`: who the token is meant for

You can think of `iss` as "who signed this," `sub` as "who this says I am," and `aud` as "who should accept it."

## Why `id-token: write` is not cloud write access

`id-token: write` allows the job to ask GitHub for an OIDC token. It does not directly grant Google Cloud permissions. Google Cloud permissions appear only if:

1. the token is accepted by the WIF provider
2. the mapped claims satisfy the attribute condition
3. the resulting federated principal is allowed to impersonate a service account
4. that service account has useful IAM roles

This layered design is one of the most important ideas in the lab.

## Safe decoding exercise

Use the `OIDC Claims Debug` workflow. Decode and inspect only the payload fields you need. Do not print the raw token. Even though the claims are not credentials, they still reveal operational metadata.

## Reflection questions

1. Which claim most directly ties the token to a specific workflow file?
2. Why is `environment` helpful for separating staging and production trust?
3. If a job has `id-token: write` but no trusted WIF provider, what useful cloud action can it perform?
