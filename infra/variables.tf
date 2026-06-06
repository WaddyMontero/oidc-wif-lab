variable "project_id" {
  description = "GCP project ID that will host the lab resources."
  type        = string
}

variable "region" {
  description = "Region used for Artifact Registry and Cloud Run."
  type        = string
  default     = "us-central1"
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name only, without the owner prefix."
  type        = string
}

variable "staging_branch" {
  description = "Dedicated branch allowed to deploy the staging environment."
  type        = string
  default     = "staging"
}

variable "production_branch" {
  description = "Protected branch that production trust is anchored to."
  type        = string
  default     = "main"
}

variable "allow_unauthenticated" {
  description = "Whether Cloud Run should allow unauthenticated invocation. Off by default so public access is a conscious teaching choice."
  type        = bool
  default     = false
}

variable "bootstrap_image" {
  description = "Placeholder image used for the first Cloud Run deployment before CI/CD pushes a lab-specific image."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}
