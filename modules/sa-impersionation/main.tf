# Create the service account in each project
resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id
}

resource "google_organization_iam_member" "org_bindings" {
  for_each = toset(var.org_roles)

  org_id = var.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_iam_member" "sa_bindings" {
  for_each = toset(var.sa_roles)

  service_account_id = google_service_account.service_account.name
  role               = each.key
  member             = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_iam_member" "impersonator_bindings" {
  for_each = toset(var.impersonators)

  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.value}"
}
# Apply IAM binding for the Workload Identity User
resource "google_service_account_iam_binding" "wif_binding" {
  service_account_id = "projects/${var.target_project}/serviceAccounts/${google_service_account.service_account.account_id}@${var.target_project}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${var.github_pool_name}/attribute.repository/${var.github_organisation}/${var.github_repository}",
    "principalSet://iam.googleapis.com/${var.github_pool_name}/attribute.repository_owner/${var.github_organisation}"
  ]
}