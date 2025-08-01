resource "google_project_iam_member" "project_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = var.member
}