variable "project_id" {
  type        = string
  description = "The ID of the GCP project"
}

# Identity pool

variable "pool_id" {
  type        = string
  description = "Workload Identity Pool ID"
  validation {
    condition     = substr(var.pool_id, 0, 4) != "gcp-" && length(regex("([a-z0-9-]{4,32})", var.pool_id)) == 1
    error_message = "The pool_id value should be 4-32 characters, and may contain the characters [a-z0-9-]."
  }
}

variable "pool_display_name" {
  type        = string
  description = "Display name for the Workload Identity Pool"
  default     = null
}

variable "pool_description" {
  type        = string
  description = "Description for the Workload Identity Pool"
  default     = "Workload Identity Pool managed by Terraform"
}

variable "pool_disabled" {
  type        = bool
  description = "Whether the Workload Identity Pool is disabled"
  default     = false
}

# Identity pool provider

variable "provider_id" {
  type        = string
  description = "Workload Identity Pool Provider ID"
  validation {
    condition     = substr(var.provider_id, 0, 4) != "gcp-" && length(regex("([a-z0-9-]{4,32})", var.provider_id)) == 1
    error_message = "The provider_id value should be 4-32 characters, and may contain the characters [a-z0-9-]."
  }
}

variable "provider_display_name" {
  type        = string
  description = "Display name for the Workload Identity Provider"
  default     = null
}

variable "provider_description" {
  type        = string
  description = "Description for the Workload Identity Provider"
  default     = "Workload Identity Pool Provider managed by Terraform"
}

variable "provider_disabled" {
  type        = bool
  description = "Whether the Workload Identity Provider is disabled"
  default     = false
}

variable "attribute_mapping" {
  type        = map(any)
  description = "Attribute mapping for the Workload Identity Provider"
  default = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
}

variable "attribute_condition" {
  type        = string
  description = "Attribute condition expression"
  default     = "attribute.repository == assertion.repository && attribute.repository_owner == assertion.repository_owner"
}

variable "allowed_audiences" {
  type        = list(string)
  description = "List of allowed audiences for the OIDC provider"
  default     = []
}

variable "issuer_uri" {
  type        = string
  description = "OIDC issuer URL (e.g., https://token.actions.githubusercontent.com)"
}
/**
variable "service_account_name" {
  type        = string
  description = "Service Account ID (without domain)"
}

variable "github_organisation" {
  type        = string
  description = "GitHub organization or username that owns the repository"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository name (e.g., my-repo)"
}
**/