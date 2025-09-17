```hcl
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
  region  = var.region
  name    = var.router_name
  network = var.network_name
}

resource "google_compute_router_nat" "cloud_nat" {
  project                            = var.project_id
  region                             = var.region
  name                               = var.nat_name
  router                             = google_compute_router.cloud_router.name
  nat_ip_allocate_mode               = var.nat_ip_allocate_mode
  nat_ips                            = var.nat_ip_allocate_mode == "MANUAL_ONLY" ? var.nat_ips : null
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.subnetworks_to_nat : []
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = lookup(subnetwork.value, "secondary_ip_range_names", null)
    }
  }

  log_config {
    enable = var.log_config_enable
    filter = var.log_config_filter
  }

  min_ports_per_vm                 = var.min_ports_per_vm
  icmp_idle_timeout_sec            = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec
}






}


}
))
  default = []
}


}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated
