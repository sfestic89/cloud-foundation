resource "google_storage_bucket" "my_bucket_set" {
  project       = var.project_id

  for_each      = toset(var.bucket_name_set)
  name          = each.value
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true
  soft_delete_policy {
    retention_duration_seconds = 0
  }

  uniform_bucket_level_access = true

  lifecycle {
    prevent_destroy = false
  }
}