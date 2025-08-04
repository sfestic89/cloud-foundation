/**
resource "google_folder_iam_member" "folder_roles" {
  for_each = toset(var.roles)

  folder = var.folder_id
  role   = each.value
  member = var.member
}
**/
locals {
  # Flatten the iam_bindings map into a list of role-member pairs
  bindings = flatten([
    for role, members in var.iam_bindings : [
      for member in members : {
        role   = role
        member = member
      }
    ]
  ])
}

resource "google_folder_iam_member" "folder_roles" {
  for_each = {
    for binding in local.bindings :
    "${binding.role}-${binding.member}" => binding
  }

  folder = var.folder_id
  role   = each.value.role
  member = each.value.member
}