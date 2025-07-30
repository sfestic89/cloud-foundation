variable "projects" {
  type = list(object({
    project_id      = string
    name            = string
    folder_id       = string
    billing_account = string
    labels          = map(string)
  }))
}
variable "gcp_service_list" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}
