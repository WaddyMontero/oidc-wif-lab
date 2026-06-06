# Deploy Runbook

## Staging

- Merge or push to `staging`.
- Watch `Deploy Staging`.
- Confirm the new revision in Cloud Run.
- Check `/metadata` to verify `APP_ENVIRONMENT` and `APP_GIT_SHA`.

## Production

- Review the staging result first, then promote intentionally into `main` however your team prefers.
- Start `Deploy Production` manually.
- Require environment approval if configured.
- Confirm the production revision and metadata.
