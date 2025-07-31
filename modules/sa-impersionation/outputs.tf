output "service_account_id" {
  description = "The ID of the created service account"
  value       = google_service_account.service_account.account_id
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.service_account.email
}

output "service_account_name" {
  description = "Fully qualified name of the service account"
  value       = google_service_account.service_account.name
}