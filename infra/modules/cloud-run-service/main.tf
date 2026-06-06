resource "google_cloud_run_v2_service" "this" {
  name                = var.service_name
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

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

      # These values make the first Terraform apply produce something runnable,
      # while later GitHub Actions deployments can override the image and SHA.
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
