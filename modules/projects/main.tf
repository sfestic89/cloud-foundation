locals {
  project_api_map = {
    for pair in flatten([
      for p in var.projects : [
        for api in p.apis : {
          key        = "${p.project_id}-${api}"
          project_id = p.project_id
          api        = api
        }
      ]
    ]) : pair.key => pair
  }
}

resource "google_project" "this" {
  for_each = { for p in var.projects : p.project_id => p }

  project_id      = each.value.project_id
  name            = each.value.name
  folder_id       = each.value.folder_id
  billing_account = each.value.billing_account
  labels          = each.value.labels
}

resource "google_project_service" "gcp_services" {
  for_each = local.project_api_map

  project = each.value.project_id
  service = each.value.api
}