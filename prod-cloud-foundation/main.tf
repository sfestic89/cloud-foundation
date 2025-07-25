module "bootstrap_folders" {
  source = "../modules/folders"
  parent = "organizations/718865262377"
  folder_names = [
    "bootstrap",
    "common",
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
        "cloudresourcemanager.googleapis.com",
        "iam.googleapis.com",
        "storage.googleapis.com"
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
        "iam.googleapis.com",
        "sts.googleapis.com"
      ]
    }
  ]
}

module "ccoe_terraform_sa" {
  source       = "../modules/service-accounts"
  project_id   = module.projects.project_ids["ccoe-seed-project"] # or module.project.project_id
  account_id   = "ccoe-terraform"
  display_name = "Terraform Infra SA"
  org_id       = "718865262377"

  org_roles = [
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/iam.workloadIdentityPoolViewer"
  ]
}

module "wif" {
  source     = "../modules/wif"
  project_id = module.projects.project_ids["ccoi-wif-project"]

  pool_id               = "ccoi-github-pool"
  pool_display_name     = "CCOI GitHub Pool"
  provider_id           = "github"
  provider_display_name = "GitHub Actions"
  issuer_uri            = "https://token.actions.githubusercontent.com"
  allowed_audiences     = ["https://github.com/sfestic89/cloud-foundation"]
}

module "github_impersonation" {
  source = "../modules/sa-impersionation"

  target_project         = module.projects.project_ids["ccoe-seed-project"]
  service_account_id     = module.ccoe_terraform_sa.service_account_id
  service_account_email  = module.ccoe_terraform_sa.service_account_email
  github_organisation    = "718865262377"
  github_repository      = "sfestic89"
  central_project_number = module.projects.project_numbers["ccoi-wif-project"]
  pool_id                = "ccoi-github-pool"

  depends_on = [module.wif]
}

module "state_bucket" {
  source = "../modules/cloud-storage" # adjust the path

  project_id      = module.projects.project_ids["ccoe-seed-project"]
  bucket_name_set = ["tf-state-ccoe-seed"]
  bucket_location = "EU"
  storage_class   = "STANDARD"
}