resource "google_service_account_iam_binding" "wif_binding" {
  service_account_id = var.service_account_id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${var.github_pool_name}/attribute.repository/${var.github_organisation}/${var.github_repository}",
    "principalSet://iam.googleapis.com/${var.github_pool_name}/attribute.repository_owner/${var.github_organisation}"
  ]
}