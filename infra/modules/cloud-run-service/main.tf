resource "google_cloud_run_v2_service" "this" {
  name                = var.service_name
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0].scaling,
      template[0].containers[0].image,
      template[0].containers[0].env,
    ]
  }

  template {
    service_account = var.runtime_service_account_email

    containers {
      image = var.image

      ports {
        container_port = 8080
      }

      env {
        name  = "APP_ENVIRONMENT"
        value = var.environment
      }

      # These values bootstrap the first deploy. After that, the GitHub deploy
      # workflow becomes the source of truth for the image tag and deployment
      # metadata, so Terraform ignores drift on the runtime-owned container
      # fields rather than reverting the service back to the placeholder image.
      env {
        name  = "APP_GIT_SHA"
        value = "bootstrap"
      }

      env {
        name  = "APP_DEPLOYED_BY"
        value = "terraform-bootstrap"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = google_cloud_run_v2_service.this.project
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
