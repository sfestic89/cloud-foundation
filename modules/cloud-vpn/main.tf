terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_router" "cloud_router" {
  project = var.project_id
  name    = var.router_name
  region  = var.region
  network = var.network_name
}

resource "google_compute_router_nat" "cloud_nat" {
  project                            = var.project_id
  name                               = var.nat_name
  router                             = google_compute_router.cloud_router.name
  region                             = google_compute_router.cloud_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "project_id" {
  description = "The ID of the GCP project where the Cloud NAT will be created."
  type        = string
}

variable "region" {
  description = "The region where the Cloud Router and NAT will be created (e.g., 'us-central1')."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network where the Cloud Router will operate."
  type        = string
}

variable "router_name" {
  description = "The name for the Cloud Router resource."
  type        = string
  default     = "cloud-nat-router"
}

variable "nat_name" {
  description = "The name for the Cloud NAT gateway resource."
  type        = string
  default     = "cloud-nat-gateway"
}

output "router_name" {
  description = "The name of the created Cloud Router."
  value       = google_compute_router.cloud_router.name
}

output "nat_name" {
  description = "The name of the created Cloud NAT gateway."
  value       = google_compute_router_nat.cloud_nat.name
}

output "nat_ips" {
  description = "The list of external IP addresses allocated to the Cloud NAT gateway."
  value       = google_compute_router_nat.cloud_nat.nat_ip_external_ips
}