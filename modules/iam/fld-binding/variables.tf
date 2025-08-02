variable "folder_id" {
  type        = string
  description = "The ID of the folder to which the IAM roles will be applied. Format: folders/1234567890"
}

variable "member" {
  type        = string
  description = "The member (user, group, or service account) to grant the roles to."
}

variable "roles" {
  type        = list(string)
  description = "A list of roles to assign at the folder level."
}