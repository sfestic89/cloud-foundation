variable "target_project" {
  description = "Target project to create the service account in"
  type        = string
}

variable "service_account_id" {
  description = "Service account ID (without domain)"
  type        = string
}

variable "service_account_email" {
  description = "Service account email (with domain)"
  type        = string
}

variable "github_organisation" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "central_project_number" {
  description = "Project number of the WIF hosting project"
  type        = string
}

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
}