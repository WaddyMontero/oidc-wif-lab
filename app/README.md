# Application

This is a deliberately tiny FastAPI service used by the lab.

It exposes three endpoints:

- `GET /` for a simple hello response.
- `GET /healthz` for a minimal health endpoint.
- `GET /metadata` for a tightly controlled view of non-sensitive deployment metadata.

The app is intentionally boring because the lab is about identity and deployment trust boundaries, not application complexity.
