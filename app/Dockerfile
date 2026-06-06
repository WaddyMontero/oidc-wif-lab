FROM python:3.12-slim

# These environment variables keep Python predictable in containers:
# - no .pyc files
# - unbuffered logs so Cloud Run log streaming is clearer
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

# Create a non-root user so the app does not run with unnecessary privileges.
RUN adduser --disabled-password --gecos "" appuser

# Copy dependency manifests first so Docker layer caching works as expected.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only the application source needed at runtime.
COPY src ./src

USER appuser

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
