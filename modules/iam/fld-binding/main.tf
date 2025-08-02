resource "google_folder_iam_member" "folder_roles" {
  for_each = toset(var.roles)

  folder = var.folder_id
  role   = each.value
  member = var.member
}