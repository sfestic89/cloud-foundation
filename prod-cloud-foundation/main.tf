module "bootstrap_folders" {
  source = "../modules/folders"
  parent = "organizations/718865262377"
  folder_names = [
    "bootstrap",
    "common",
    "rearc"
  ]
}
module "projects" {
  source = "../modules/projects"

  projects = [
    {
      project_id      = "ccoe-seed-project"
      name            = "CCOE Seed Project"
      folder_id       = module.bootstrap_folders.folder_ids["bootstrap"]
      billing_account = "01BAAE-738DCF-3581B5"
      labels = {
        environment = "bootstrap"
        owner       = "terraform"
      }
      apis = [
        "serviceusage.googleapis.com",
        "cloudbilling.googleapis.com",
        "compute.googleapis.com",
        "storage.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "iamcredentials.googleapis.com",
        "iam.googleapis.com"
      ]
    },
    {
      project_id      = "ccoi-wif-project"
      name            = "Workload Identity Federation"
      folder_id       = module.bootstrap_folders.folder_ids["common"]
      billing_account = "01BAAE-738DCF-3581B5"
      labels = {
        env = "common"
      }
      apis = [
        "serviceusage.googleapis.com",
        "cloudbilling.googleapis.com",
        "compute.googleapis.com",
        "storage.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "iamcredentials.googleapis.com",
        "iam.googleapis.com"
      ]
    },
    {
      project_id      = "rearc-quest-project"
      name            = "Rearc Quest Project"
      folder_id       = module.bootstrap_folders.folder_ids["rearc"]
      billing_account = "01BAAE-738DCF-3581B5"
      labels = {
        environment = "demo"
        owner       = "sfestic"
      }
      apis = [
        "serviceusage.googleapis.com",
        "compute.googleapis.com",
        "storage.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "iamcredentials.googleapis.com",
        "iam.googleapis.com",
        "artifactregistry.googleapis.com",
        "cloudbuild.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
        "run.googleapis.com"
      ]
    }
  ]
}
module "state_bucket" {
  source = "../modules/cloud-storage" # adjust the path

  project_id      = module.projects.project_ids["ccoe-seed-project"]
  bucket_name_set = ["tf-state-ccoe-seed"]
  bucket_location = "EU"
  storage_class   = "STANDARD"
}

module "cloud_fundation_wif" {
  source = "../modules/wif"

  project_id        = module.projects.project_ids["ccoi-wif-project"] #"ccoi-wif-project"
  pool_id           = "lz-github-pool"
  pool_display_name = "Github Landing Zone Pool"
  pool_description  = "Manage Landing Zone with GitHub Actions"
  pool_disabled     = false

  provider_id           = "lz-provider"
  provider_display_name = "GitHub OIDC Provider"
  provider_description  = "Provider for GitHub OIDC federation"
  provider_disabled     = false

  issuer_uri        = "https://token.actions.githubusercontent.com"
  allowed_audiences = ["https://github.com/sfestic89/cloud-foundation"]
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "attribute.repository == assertion.repository && attribute.repository_owner == assertion.repository_owner"
}

module "wif_sa" {
  source     = "../modules/service-accounts"
  project_id = module.projects.project_ids["ccoe-seed-project"]
  service_accounts = {
    "wif-tf-sa" = {
      display_name = "WIF Terraform SA"
      description  = "Used by CI/CD pipelines"
      disabled     = false
    }
  }
}

module "wif_sa_org_roles" {
  source = "../modules/iam/org-binding"

  org_id = "718865262377"
  roles = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/orgpolicy.policyAdmin",
    "roles/iam.organizationRoleAdmin",
    "roles/iam.securityAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/billing.user"
  ]
  member = "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
}

module "wif_sa_seed_prj_roles" {
  source = "../modules/iam/prj-binding"

  project_id = module.projects.project_ids["ccoe-seed-project"]
  roles = [
    "roles/storage.admin"
  ]
  member = "serviceAccount:${module.wif_sa.service_account_emails["wif-tf-sa"]}"
}
module "wif-sa-impersionation" {
  source = "../modules/iam/impersionation"

  target_project      = "ccoe-seed-project"
  service_account_id  = module.wif_sa.service_account_names["wif-tf-sa"]
  github_pool_name    = module.cloud_fundation_wif.pool_name
  github_organisation = "sfestic89"
  github_repository   = "cloud-foundation"
}
/**
module "rearc_wif_provider" {
  source = "../modules/wif"

  project_id            = module.projects.project_ids["ccoi-wif-project"]
  pool_id               = "rearc-github-pool"
  pool_display_name = "Github Rearc Zone Pool"
  pool_description  = "Managing Rearc Project with Github Actions"
  pool_disabled     = false

  provider_id           = "github-provider"
  provider_display_name = "GitHub Rearc Quest Provider"
  provider_description  = "Provider for rearc-quest repo"
  provider_disabled     = false

  issuer_uri            = "https://token.actions.githubusercontent.com"
  allowed_audiences     = ["https://github.com/sfestic89/rearc-quest"]
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "attribute.repository == 'sfestic89/rearc-quest'"
}
/**
module "impersonation_rearc" {
  source             = "../modules/sa-impersionation"
  target_project     = "rearc-quest-project"                              # 🔹 target is rearc project
  project_id         = module.projects.project_ids["rearc-quest-project"] # 🔹 rearc project id
  display_name       = "GitHub Deployer Rearc Quest"
  account_id         = "rearc-deployer" # This creates github-deployer@rearc-quest-project
  service_account_id = "rearc-gh-deployer"

  github_organisation = "sfestic89"
  github_repository   = "rearc-quest" # 🔹 different repo

  central_project_number = "726010183755"
  pool_id                = module.rearc_wif_provider.pool_id   # or your central WIF pool
  github_pool_name       = module.rearc_wif_provider.pool_name # workload identity pool name for rearc repo

  org_id = "718865262377" # use if needed, or leave empty if no org-level roles

  org_roles = [] # Rearc SA probably doesn't need org-level roles
  sa_roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator"
  ]
  #impersonators = [
  #"ccoegithub-terraform@ccoe-seed-project.iam.gserviceaccount.com"
  #]
}
module "rearc_wif_provider" {
  source = "../modules/wif"

  project_id            = "ccoi-wif-project"
  pool_id               = "rearc-quest-wif-pool"
  provider_id           = "github-provider"
  provider_display_name = "GitHub Rearc Quest Provider"
  provider_description  = "OIDC provider for rearc-quest repo"
  provider_disabled     = false
  issuer_uri            = "https://token.actions.githubusercontent.com"
  allowed_audiences     = ["https://github.com/sfestic89/rearc-quest"]
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "attribute.repository == 'sfestic89/rearc-quest'"
}

module "rearc_quest_prj_iam" {
  source = "../modules/iam"

  project_id = "rearc-quest-project"
  member     = "serviceAccount:rearc-deployer@rearc-quest-project.iam.gserviceaccount.com"
  roles = [
    "roles/artifactregistry.admin",
    "roles/cloudbuild.builds.editor",
    "roles/run.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser"
  ]
}
**/