resource "google_project" "this" {
  for_each = { for p in var.projects : p.project_id => p }

  project_id      = each.value.project_id
  name            = each.value.name
  folder_id       = each.value.folder_id
  billing_account = each.value.billing_account
  labels          = each.value.labels
}
resource "google_project_service" "gcp_services" {
  for_each = {
    for pair in flatten([
      for project in var.projects : [
        for api in var.gcp_service_list : {
          key        = "${project.project_id}-${api}"
          project_id = project.project_id
          api        = api
        }
      ]
    ]) : pair.key => pair
  }

  project = each.value.project_id
  service = each.value.api
}