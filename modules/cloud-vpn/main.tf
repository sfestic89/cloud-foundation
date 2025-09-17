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

variable "project_id" {
  type = string
  description = "The ID of the project in which to provision resources."
}

variable "region" {
  type = string
  description = "The region in which to provision resources."
  default = "us-central1"
}

variable "network" {
  type = string
  description = "The name of the VPC network."
  default = "default"
}

variable "vpn_gateway_name" {
  type = string
  description = "Name of the VPN gateway."
  default = "vpn-gw"
}

variable "router_name" {
  type = string
  description = "Name of the Cloud Router."
  default = "cloud-router"
}

variable "peer_ip_address" {
  type = string
  description = "Peer IP address for the VPN tunnel."
}

variable "shared_secret" {
  type = string
  description = "Shared secret for the VPN tunnel."
  sensitive = true
}

resource "google_compute_address" "vpn_ip" {
  name         = "${var.vpn_gateway_name}-ip"
  address_type = "EXTERNAL"
  region       = var.region
  project      = var.project_id
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = var.vpn_gateway_name
  region  = var.region
  network = var.network
  project = var.project_id
}

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = var.network
  project = var.project_id
  bgp {
    asn = 65001
  }
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name                         = "${var.vpn_gateway_name}-tunnel"
  region                       = var.region
  vpn_gateway                  = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip                      = var.peer_ip_address
  shared_secret                = var.shared_secret
  router                       = google_compute_router.router.name
  ike_version                  = 2
  project                      = var.project_id
}