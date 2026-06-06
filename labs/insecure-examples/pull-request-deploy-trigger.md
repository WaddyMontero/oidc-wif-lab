# Insecure Example: Deploy on Pull Request

Bad idea:

```yaml
on:
  pull_request:
```

Why it is dangerous:

- it increases the chance that untrusted or partially reviewed changes reach cloud deploy logic
- it shortens the path from repository compromise to runtime impact
