variable "service_account_id" {
  type        = string
  description = "The fully qualified service account name, e.g. projects/my-project/serviceAccounts/my-sa@my-project.iam.gserviceaccount.com"
}

variable "member" {
  type        = string
  description = "The member to assign roles to, e.g. serviceAccount:xyz@abc.iam.gserviceaccount.com"
}

variable "roles" {
  type        = list(string)
  description = "A list of IAM roles to bind to the member for the service account."
}
