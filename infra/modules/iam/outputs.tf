output "runtime_service_account_email" {
  value = google_service_account.runtime.email
}

output "runtime_service_account_name" {
  value = google_service_account.runtime.name
}

output "deployer_service_account_email" {
  value = google_service_account.deployer.email
}

output "deployer_service_account_name" {
  value = google_service_account.deployer.name
}
