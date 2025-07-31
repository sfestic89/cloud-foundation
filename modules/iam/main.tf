resource "google_project_iam_member" "project_roles" {
  # The for_each loop iterates over the list of roles provided.
  # The `each.key` value will be each role string in the list.
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.key
  member  = var.member
}