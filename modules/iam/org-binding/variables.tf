variable "org_id" {
  type        = string
  description = "The ID of the organization to which the IAM roles will be applied."
}

variable "member" {
  type        = string
  description = "The member (user, group, or service account) to grant the roles to."
}

variable "roles" {
  type        = list(string)
  description = "A list of roles to assign at the organization level."
}