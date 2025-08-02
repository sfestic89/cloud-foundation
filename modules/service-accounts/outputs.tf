output "service_account_emails" {
  description = "Map of service account emails, keyed by account_id"
  value = {
    for k, sa in google_service_account.sa_creation :
    k => sa.email
  }
}

output "service_account_names" {
  description = "Map of fully-qualified service account resource names"
  value = {
    for k, sa in google_service_account.sa_creation :
    k => sa.name
  }
}

output "service_account_ids" {
  description = "Map of service account unique IDs"
  value = {
    for k, sa in google_service_account.sa_creation :
    k => sa.unique_id
  }
}