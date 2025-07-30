variable "projects" {
  type = list(object({
    project_id      = string
    name            = string
    folder_id       = string
    billing_account = string
    labels          = map(string)
    apis            = list(string)
  }))
}
