resource "google_service_account" "sa_creation" {
  for_each     = var.service_accounts
  account_id   = each.key
  display_name = each.value.display_name
  project      = var.project_id

  description = lookup(each.value, "description", null)
  disabled    = lookup(each.value, "disabled", null)
}