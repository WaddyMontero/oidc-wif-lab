# Secure Reference

This folder is the conceptual baseline for the lab:

- separate staging and production trust boundaries
- no service account keys
- no `roles/owner`
- no `roles/editor`
- deploy-only OIDC permissions
- staging tied to a dedicated integration branch instead of `main`
- manual production release path

Use the main repository implementation as the working secure reference.
