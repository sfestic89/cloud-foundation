resource "google_storage_bucket_iam_member" "gcs_bindings" {
  for_each = {
    for role in var.roles : role => role
  }

  bucket = var.bucket_name
  role   = each.value
  member = var.member
}

#member = "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#role   = "roles/storage.admin"