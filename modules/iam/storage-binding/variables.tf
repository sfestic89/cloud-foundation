variable "member" {
  type        = string
  description = "The member to assign roles to, e.g. serviceAccount:xyz@abc.iam.gserviceaccount.com"
}

variable "roles" {
  type        = list(string)
  description = "A list of IAM roles to bind to the member for the service account."
}

variable "bucket_name" {
  type        = string
  description = "The name of the GCS bucket."
}