# Answer Key

## Quiz 1

1. It allows a workflow job to request an OIDC token from GitHub. It does not directly grant cloud permissions.
2. `aud` helps the relying party reject tokens meant for some other audience.
3. `iss` is the issuer and `sub` is the subject.
4. The raw token is bearer material for a short time, so printing it is unnecessary exposure.

## Quiz 2

1. The pool is the trust container; the provider is the concrete OIDC configuration inside it.
2. Attribute mapping copies selected claims into Google attributes.
3. The attribute condition is the policy gate that decides whether the token should be trusted.
4. It allows a trusted federated principal to impersonate a service account.

## Quiz 3

1. It trusts every admitted principal in the pool instead of a narrow subset.
2. It reduces cross-environment blast radius.
3. The workflow may gain access to many unrelated project capabilities.
4. The runtime service account represents the running app; the deployer service account represents the deployment automation.
5. It depends on the service account roles, trusted event path, and environment protections.
