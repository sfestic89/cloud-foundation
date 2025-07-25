variable "project_id" {
  description = "The ID of the GCP project where the buckets will be created"
  type        = string
}

variable "bucket_name_set" {
  description = "Set of GCS bucket names to create"
  type        = set(string)
}

variable "bucket_location" {
  description = "The location where the buckets will be created (e.g., 'US', 'EU', 'us-central1')"
  type        = string
}

variable "storage_class" {
  description = "The storage class for the bucket (e.g., 'STANDARD', 'NEARLINE', 'COLDLINE', 'ARCHIVE')"
  type        = string
  default     = "STANDARD"
}