terraform {
  backend "gcs" {
    bucket = "tf-state-ccoe-seed"
    prefix = "terraform/state"
  }
}