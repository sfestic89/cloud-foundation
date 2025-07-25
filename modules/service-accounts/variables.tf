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