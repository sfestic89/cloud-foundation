variable "folder_id" {
  type        = string
  description = "The ID of the folder to which IAM roles will be applied."
}

variable "iam_bindings" {
  type        = map(list(string))
  description = "A map of IAM roles to a list of members to bind at the folder level."
}