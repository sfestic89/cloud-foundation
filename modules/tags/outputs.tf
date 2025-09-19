
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

output "tag_value_ids_by_key" {
  description = "Nested map: tag_key_short_name => (tag_value_short_name => tagValue ID)"
  value = {
    for k, vals in var.tags_to_create :
    k => {
      for v in vals :
      v => google_tags_tag_value.project_tag_value["${k}-${v}"].id
    }
  }
}