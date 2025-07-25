resource "google_folder" "folders" {
  for_each = toset(var.folder_names)

  display_name = each.key
  parent       = var.parent
}