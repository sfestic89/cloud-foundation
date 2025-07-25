/**
resource "google_service_account" "service_account" {
  project      = var.target_project
  account_id   = var.service_account_id
  display_name = "GitHub Deploy Service Account"
}
**/
resource "google_service_account_iam_binding" "wif_impersonation" {
  service_account_id = "projects/${var.target_project}/serviceAccounts/${var.service_account_email}"
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/projects/${var.central_project_number}/locations/global/workloadIdentityPools/${var.pool_id}/attribute.repository/${var.github_organisation}/${var.github_repository}",
    "principalSet://iam.googleapis.com/projects/${var.central_project_number}/locations/global/workloadIdentityPools/${var.pool_id}/attribute.repository_owner/${var.github_organisation}"
  ]
}