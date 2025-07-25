resource "google_project" "this" {
  for_each       = { for p in var.projects : p.project_id => p }

  project_id     = each.value.project_id
  name           = each.value.name
  folder_id      = each.value.folder_id
  billing_account = each.value.billing_account
  labels         = each.value.labels
}