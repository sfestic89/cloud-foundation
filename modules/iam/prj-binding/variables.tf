/**
variable "project_id" {
  type        = string
  description = "The ID of the project to which the IAM roles will be applied."
}

variable "member" {
  type        = string
  description = "The service account or user to grant the roles to."
}

variable "roles" {
  type        = list(string)
  description = "A list of role names to grant to the member."
}
**/
variable "project_id" {
  type        = string
  description = "The ID of the project to which the IAM roles will be applied."
}

variable "iam_bindings" {
  type        = map(list(string))
  description = "A map of IAM roles to a list of members for the project."
}