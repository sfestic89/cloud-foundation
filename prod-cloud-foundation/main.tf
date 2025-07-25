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
        "storage.googleapis.com",
        "iamcredentials.googleapis.com"
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
    "roles/iam.workloadIdentityPoolViewer",
    "roles/storage.admin"
  ]
}

module "impersonation" {
  source                 = "../modules/sa-impersionation"
  target_project         = "ccoe-seed-project"
  project_id             = module.projects.project_ids["ccoe-seed-project"]
  display_name           = "Terraform Github Infra SA"
  account_id             = "ccoegithub-terraform"
  service_account_id     = "github-deployer"
  github_organisation    = "sfestic89"
  github_repository      = "cloud-foundation"
  central_project_number = "726010183755"
  pool_id                = module.wif.pool_id
  github_pool_name       = module.wif.pool_name

  org_id = "718865262377" # Replace with your actual org ID
  org_roles = [
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/iam.workloadIdentityPoolViewer",
    "roles/storage.admin"
  ]
}

module "wif" {
  source = "../modules/wif"

  project_id        = "ccoi-wif-project"
  pool_id           = "cloud-infra-github-pool"
  pool_display_name = "GitHub Workload Identity Pool"
  pool_description  = "Federation pool for GitHub Actions"
  pool_disabled     = false

  provider_id           = "cloud-infra-github-pool"
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

module "state_bucket" {
  source = "../modules/cloud-storage" # adjust the path

  project_id      = module.projects.project_ids["ccoe-seed-project"]
  bucket_name_set = ["tf-state-ccoe-seed"]
  bucket_location = "EU"
  storage_class   = "STANDARD"
}