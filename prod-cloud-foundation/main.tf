module "org_policy" {
  source = "../modules/org-policy/boolean-policy"

  target_resource = "organizations/718865262377" # or a folder/project if needed

  policies = {
    "compute.skipDefaultNetworkCreation" = {
      enforce     = false # true → tags ignored
      policy_type = "deny"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    },
    "storage.uniformBucketLevelAccess" = {
      enforce     = false # true → tags ignored
      policy_type = "deny"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    },
    "iam.disableServiceAccountKeyUpload" = {
      enforce     = false # true → tags ignored
      policy_type = "allow"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    },
    "compute.requireShieldedVm" = {
      enforce     = false
      policy_type = "allow"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    },
    "iam.disableServiceAccountCreation" = {
      enforce     = false
      policy_type = "allow"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    }, 
    "compute.skipDefaultNetworkCreation" = {
      enforce     = false # true → tags ignored
      policy_type = "deny"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    },
    "storage.uniformBucketLevelAccess" = {
      enforce     = false # true → tags ignored
      policy_type = "deny"
      tag_key     = "718865262377/env"
      tag_value   = "prod"
    }
  }
}

module "org_policy_list" {
  source          = "../modules/org-policy/list-constraints"
  target_resource = "organizations/718865262377"

  policies = {
    # Allow only specific locations in prod (else allow all)
    "compute.trustedImageProjects" = {
      mode          = "allow"
      values        = ["projects/debian-cloud", "projects/ubuntu-os-cloud"]
      enforce       = false
      tag_key       = "718865262377/env"
      tag_value     = "prod"
    }
  }
}

module "project_tags" {
  source = "../modules/tags" # relative path to your module

  project_id     = module.projects.project_ids["ccoe-seed-project"]
  tag_key_parent = "organizations/718865262377"

  tags_to_create = {
    "env"   = ["dev"]
    "owner" = ["devops"]
  }
}

# module "bootstrap_folders" {
#   source = "../modules/folders"
#   parent = "organizations/718865262377"
#   folder_names = [
#     "bootstrap",
#     "common",
#     "rearc"
#   ]
# }
# module "folder_iam_bindings" {
#   source    = "../modules/iam/fld-binding"
#   folder_id = module.bootstrap_folders.folder_ids["common"]

#   iam_bindings = {
#     "roles/logging.admin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}",
#     ],
#     "roles/monitoring.admin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ],
#     "roles/iam.serviceAccountAdmin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ]
#     "roles/serviceusage.serviceUsageAdmin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ]
#   }
# }
# module "projects" {
#   source = "../modules/projects"

#   projects = [
#     {
#       project_id      = "ccoe-seed-project"
#       name            = "CCOE Seed Project"
#       folder_id       = module.bootstrap_folders.folder_ids["bootstrap"]
#       billing_account = "01BAAE-738DCF-3581B5"
#       labels = {
#         environment = "bootstrap"
#         owner       = "terraform"
#       }
#       apis = [
#         "orgpolicy.googleapis.com",
#         "serviceusage.googleapis.com",
#         "cloudbilling.googleapis.com",
#         "compute.googleapis.com",
#         "storage.googleapis.com",
#         "cloudresourcemanager.googleapis.com",
#         "iamcredentials.googleapis.com",
#         "iam.googleapis.com"
#       ]
#     },
#     {
#       project_id      = "ccoi-wif-project"
#       name            = "Workload Identity Federation"
#       folder_id       = module.bootstrap_folders.folder_ids["common"]
#       billing_account = "01BAAE-738DCF-3581B5"
#       labels = {
#         env = "common"
#       }
#       apis = [
#         "serviceusage.googleapis.com",
#         "cloudbilling.googleapis.com",
#         "compute.googleapis.com",
#         "storage.googleapis.com",
#         "cloudresourcemanager.googleapis.com",
#         "iamcredentials.googleapis.com",
#         "iam.googleapis.com"
#       ]
#     },
#     {
#       project_id      = "rearc-quest-project"
#       name            = "Rearc Quest Project"
#       folder_id       = module.bootstrap_folders.folder_ids["rearc"]
#       billing_account = "01BAAE-738DCF-3581B5"
#       labels = {
#         environment = "demo"
#         owner       = "sfestic"
#       }
#       apis = [
#         "serviceusage.googleapis.com",
#         "compute.googleapis.com",
#         "storage.googleapis.com",
#         "cloudresourcemanager.googleapis.com",
#         "iamcredentials.googleapis.com",
#         "iam.googleapis.com",
#         "artifactregistry.googleapis.com",
#         "cloudbuild.googleapis.com",
#         "logging.googleapis.com",
#         "monitoring.googleapis.com",
#         "run.googleapis.com"
#       ]
#     }
#   ]
# }
# module "state_bucket" {
#   source = "../modules/cloud-storage" # adjust the path

#   project_id      = module.projects.project_ids["ccoe-seed-project"]
#   bucket_name_set = ["tf-state-ccoe-seed"]
#   bucket_location = "EU"
#   storage_class   = "STANDARD"
# }

# module "cloud_fundation_wif" {
#   source = "../modules/wif"

#   project_id        = module.projects.project_ids["ccoi-wif-project"] #"ccoi-wif-project"
#   pool_id           = "lz-github-pool"
#   pool_display_name = "Github Landing Zone Pool"
#   pool_description  = "Manage Landing Zone with GitHub Actions"
#   pool_disabled     = false

#   provider_id           = "lz-provider"
#   provider_display_name = "GitHub OIDC Provider"
#   provider_description  = "Provider for GitHub OIDC federation"
#   provider_disabled     = false

#   issuer_uri        = "https://token.actions.githubusercontent.com"
#   allowed_audiences = ["https://github.com/sfestic89/cloud-foundation"]
#   attribute_mapping = {
#     "google.subject"             = "assertion.sub"
#     "attribute.repository"       = "assertion.repository"
#     "attribute.repository_owner" = "assertion.repository_owner"
#   }
#   attribute_condition = "attribute.repository == assertion.repository && attribute.repository_owner == assertion.repository_owner"
# }

# module "wif_sa" {
#   source     = "../modules/service-accounts"
#   project_id = module.projects.project_ids["ccoe-seed-project"]
#   service_accounts = {
#     "wif-tf-sa" = {
#       display_name = "WIF Terraform SA"
#       description  = "Used by CI/CD pipelines"
#       disabled     = false
#     }
#   }
# }

# module "wif_sa_org_roles" {
#   source = "../modules/iam/org-binding"

#   org_id = "718865262377"
#   roles = [
#     "roles/resourcemanager.folderAdmin",
#     "roles/resourcemanager.projectCreator",
#     "roles/orgpolicy.policyAdmin",
#     "roles/orgpolicy.policyViewer", # ✅ for policy read
#     "roles/iam.organizationRoleAdmin",
#     "roles/iam.securityAdmin",
#     "roles/serviceusage.serviceUsageAdmin",
#     "roles/billing.user",
#     "roles/compute.xpnAdmin",                 # if shared VPCs used
#     "roles/accesscontextmanager.policyAdmin", # if Access Context Manager is used
#     "roles/logging.admin",                    # for centralized logging
#     "roles/monitoring.admin",                 # for monitoring resources
#     "roles/cloudkms.admin",                   # if you use CMEK
#     "roles/resourcemanager.tagAdmin",
#     "roles/resourcemanager.tagUser"
#   ]
#   member = "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
# }
# module "wif_sa_ccoe_prj_roles" {
#   source     = "../modules/iam/prj-binding"
#   project_id = module.projects.project_ids["ccoe-seed-project"]

#   iam_bindings = {
#     "roles/resourcemanager.projectIamAdmin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ],
#     "roles/resourcemanager.tagUser" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ]
#   }
# }
# module "wif_sa_wif_prj_roles" {
#   source     = "../modules/iam/prj-binding"
#   project_id = module.projects.project_ids["ccoi-wif-project"]

#   iam_bindings = {
#     "roles/iam.workloadIdentityPoolAdmin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ],
#     "roles/resourcemanager.projectIamAdmin" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ],
#     "roles/resourcemanager.tagUser" = [
#       "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
#     ]
#   }
# }
# module "gcs_tf_state_iam_bindings" {
#   source      = "../modules/iam/storage-binding"
#   bucket_name = "tf-state-ccoe-seed"
#   roles       = ["roles/storage.admin"]
#   member      = "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
# }

# module "wif-sa-impersionation" {
#   source = "../modules/iam/impersionation"

#   target_project      = "ccoe-seed-project"
#   service_account_id  = module.wif_sa.service_account_names["wif-tf-sa"]
#   github_pool_name    = module.cloud_fundation_wif.pool_name
#   github_organisation = "sfestic89"
#   github_repository   = "cloud-foundation"
# }
