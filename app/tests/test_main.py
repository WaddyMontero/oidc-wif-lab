from fastapi.testclient import TestClient

from src.main import app


client = TestClient(app)


def test_root_returns_expected_payload() -> None:
    response = client.get("/")

    assert response.status_code == 200
    assert response.json() == {
        "service": "oidc-wif-lab",
        "message": "hello from Cloud Run",
    }


def test_healthz_returns_ok() -> None:
    response = client.get("/healthz")

    assert response.status_code == 200
    assert response.json() == {"ok": True}


def test_metadata_uses_safe_defaults(monkeypatch) -> None:
    monkeypatch.delenv("APP_ENVIRONMENT", raising=False)
    monkeypatch.delenv("APP_GIT_SHA", raising=False)
    monkeypatch.delenv("APP_DEPLOYED_BY", raising=False)

    response = client.get("/metadata")

    assert response.status_code == 200
    assert response.json() == {
        "environment": "unknown",
        "git_sha": "unknown",
        "deployed_by": "github-actions",
        "service": "oidc-wif-lab",
    }
