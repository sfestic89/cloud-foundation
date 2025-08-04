/**
resource "google_project_iam_member" "project_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = var.member
}
**/
locals {
  bindings = flatten([
    for role, members in var.iam_bindings : [
      for member in members : {
        role   = role
        member = member
      }
    ]
  ])
}

resource "google_project_iam_member" "project_roles" {
  for_each = {
    for b in local.bindings : "${b.role}-${b.member}" => b
  }

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}