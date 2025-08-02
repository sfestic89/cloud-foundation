resource "google_organization_iam_member" "org_roles" {
  for_each = toset(var.roles)

  org_id = var.org_id
  role   = each.value
  member = var.member
}