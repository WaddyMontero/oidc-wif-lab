# Insecure Example: Broad Provider Condition

Bad idea:

```hcl
attribute_condition = "attribute.repository_owner == \"my-org\""
```

Why it is dangerous:

- every repository under that owner may now qualify
- branch and workflow path are not constrained
- environment separation disappears

Safer direction:
check repository, branch, environment, and workflow path together.
