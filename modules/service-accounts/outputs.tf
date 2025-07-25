output "service_account_id" {
  description = "The ID of the created service account"
  value       = google_service_account.this.account_id
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.this.email
}

output "service_account_name" {
  description = "Fully qualified name of the service account"
  value       = google_service_account.this.name
}