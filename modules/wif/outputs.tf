# Identity pool

output "pool_id" {
  description = "Identifier for the pool"
  value       = google_iam_workload_identity_pool.github_pool.id
}

output "pool_state" {
  description = "State of the pool"
  value       = google_iam_workload_identity_pool.github_pool.state
}

output "pool_name" {
  description = "Name for the pool"
  value       = google_iam_workload_identity_pool.github_pool.name
}

# Identity pool provider

output "provider_id" {
  description = "Identifier for the provider"
  value       = google_iam_workload_identity_pool_provider.github_provider
}

output "provider_state" {
  description = "State of the provider"
  value       = google_iam_workload_identity_pool_provider.github_provider
}

output "provider_name" {
  description = "Name for the provider"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}