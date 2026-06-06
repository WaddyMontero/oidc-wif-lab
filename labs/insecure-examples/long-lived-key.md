# Insecure Example: Long-Lived Key

Bad idea:

- creating a service account key
- storing it in GitHub secrets
- calling `gcloud auth activate-service-account`

Why it is dangerous:

- the secret becomes portable and leakable
- rotation and provenance get harder
- the lab no longer teaches the keyless pattern it is meant to teach
