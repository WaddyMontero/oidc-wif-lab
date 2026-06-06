import os
from typing import Dict

from fastapi import FastAPI


app = FastAPI(title="oidc-wif-lab")


def metadata_from_env() -> Dict[str, str]:
    # We only return a small allowlist of values that are useful for learning.
    # This avoids the very common mistake of dumping all environment variables,
    # which could leak credentials or other sensitive runtime configuration.
    return {
        "environment": os.getenv("APP_ENVIRONMENT", "unknown"),
        "git_sha": os.getenv("APP_GIT_SHA", "unknown"),
        "deployed_by": os.getenv("APP_DEPLOYED_BY", "github-actions"),
        "service": "oidc-wif-lab",
    }


@app.get("/")
def read_root() -> Dict[str, str]:
    return {
        "service": "oidc-wif-lab",
        "message": "hello from Cloud Run",
    }


@app.get("/healthz")
def healthcheck() -> Dict[str, bool]:
    return {"ok": True}


@app.get("/metadata")
def read_metadata() -> Dict[str, str]:
    return metadata_from_env()
