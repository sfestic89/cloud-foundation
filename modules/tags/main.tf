# Create a flattened map for all tag values, creating a unique key for each.
locals {
  tag_values = var.tags_to_create == {} ? [] : flatten([
    for tag_key, tag_values in var.tags_to_create : [
      for tag_value in tag_values : {
        key_short_name   = tag_key
        value_short_name = tag_value
      }
    ]
  ])
}
# Create the Tag Key resource. We iterate over the keys of the input map.
resource "google_tags_tag_key" "project_tag_key" {
  for_each    = var.tags_to_create
  parent      = var.tag_key_parent
  short_name  = each.key
  description = "Tag key '${each.key}' managed by Terraform for project ${var.project_id}"
}

# Create the Tag Value resources for each Tag Key.
# We iterate over the flattened list created in 'locals'.
resource "google_tags_tag_value" "project_tag_value" {
  for_each = {
    for tv in local.tag_values : "${tv.key_short_name}-${tv.value_short_name}" => tv
  }

  parent      = google_tags_tag_key.project_tag_key[each.value.key_short_name].name
  short_name  = each.value.value_short_name
  description = "Tag value '${each.value.value_short_name}' for key '${each.value.key_short_name}'"
}

# Create the Tag Binding to attach the Tag Value to the project.
resource "google_tags_tag_binding" "project_tag_binding" {
  for_each = google_tags_tag_value.project_tag_value

  parent    = "//cloudresourcemanager.googleapis.com/projects/${var.project_id}"
  tag_value = each.value.name
}