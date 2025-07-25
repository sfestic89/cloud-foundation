resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  provider                  = google-beta
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = var.pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  disabled                           = var.provider_disabled

  attribute_mapping   = var.attribute_mapping
  attribute_condition = var.attribute_condition

  oidc {
    allowed_audiences = var.allowed_audiences
    issuer_uri        = var.issuer_uri
  }
}
/**
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = var.service_account_name
  display_name = "Service Account for GitHub Deployments"
}

resource "google_service_account_iam_binding" "allow_github" {
  service_account_id = google_service_account.service_account.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_organisation}/${var.github_repository}",
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository_owner/${var.github_organisation}"
  ]
}
**/