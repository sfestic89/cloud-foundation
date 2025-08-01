variable "target_project" {
  type        = string
  description = "Target project where the service account exists"
}

variable "service_account_id" {
  type        = string
  description = "The service account ID to create in the target project"
}

variable "github_organisation" {
  type        = string
  description = "GitHub organization"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository"
}

variable "github_pool_name" {
  description = "The name of the GitHub Workload Identity Pool"
  type        = string
}