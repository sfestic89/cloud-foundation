resource "google_service_account_iam_member" "bindings" {
  for_each = {
    for role in var.roles : role => role
  }

  service_account_id = var.service_account_id
  role               = each.value
  member             = var.member
}