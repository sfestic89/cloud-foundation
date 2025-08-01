variable "project_id" {
  description = "Project to create the service account in"
  type        = string
}
variable "service_accounts" {
  description = "Map of service accounts to create. Keys are account IDs; values are configuration objects."
  type = map(object({
    display_name = string
    description  = string
    disabled     = bool
  }))
}