# Deploy Runbook

## Staging

- Merge or push to `main`.
- Watch `Deploy Staging`.
- Confirm the new revision in Cloud Run.
- Check `/metadata` to verify `APP_ENVIRONMENT` and `APP_GIT_SHA`.

## Production

- Review the staging result first.
- Start `Deploy Production` manually.
- Require environment approval if configured.
- Confirm the production revision and metadata.
