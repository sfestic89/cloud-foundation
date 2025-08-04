
output "tag_key_ids" {
  description = "A map of tag key short names to their resource IDs."
  value       = { for k, v in google_tags_tag_key.project_tag_key : k => v.id }
}

output "tag_value_ids" {
  description = "A map of tag value short names to their resource IDs."
  value       = { for k, v in google_tags_tag_value.project_tag_value : k => v.id }
}

output "tag_binding_ids" {
  description = "A map of tag bindings to their resource IDs."
  value       = { for k, v in google_tags_tag_binding.project_tag_binding : k => v.id }
}