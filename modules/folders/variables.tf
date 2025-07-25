variable "parent" {
  description = "Parent under which all folders are created (org or folder)"
  type        = string
}

variable "folder_names" {
  description = "List of folder display names"
  type        = list(string)
}