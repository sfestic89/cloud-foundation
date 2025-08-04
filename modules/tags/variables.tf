variable "project_id" {
  description = "The ID of the Google Cloud project to which tags will be applied."
  type        = string
}

variable "tags_to_create" {
  description = "A map of tag key and value pairs to create and bind to the project. The key of the map is the tag key, and the value is a list of tag values."
  type        = map(list(string))
  default     = {}
}

variable "tag_key_parent" {
  description = "The parent of the tag key. This can be the project ID or the organization ID."
  type        = string
}