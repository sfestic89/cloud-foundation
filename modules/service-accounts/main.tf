resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id
}

resource "google_organization_iam_member" "org_bindings" {
  for_each = toset(var.org_roles)

  org_id = var.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.this.email}"
}