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

variable "central_project_number" {
  type        = string
  description = "Project number of the central WIF project"
}

variable "pool_id" {
  type        = string
  description = "Workload Identity Pool ID in central project"
}

variable "github_pool_name" {
  description = "The name of the GitHub Workload Identity Pool"
  type        = string
}

variable "project_id" {
  description = "Project to create the service account in"
  type        = string
}

variable "account_id" {
  description = "Service account ID (no domain)"
  type        = string
}

variable "display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "org_id" {
  description = "The GCP organization ID for binding org-level roles"
  type        = string
}

variable "org_roles" {
  description = "List of org-level roles to bind to the service account"
  type        = list(string)
  default     = []
}