/**
output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = google_storage_bucket.my_bucket_set.name
}

output "bucket_location" {
  description = "The location of the GCS bucket"
  value       = google_storage_bucket.my_bucket_set.location
}
**/