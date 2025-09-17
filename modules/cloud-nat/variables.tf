variable "project_id" {
  description = "The ID of the GCP project where the Cloud NAT will be created."
  type        = string
}

variable "region" {
  description = "The region where the Cloud NAT will be created."
  type        = string
}

variable "router_name" {
  description = "The name of the Cloud Router to create or use."
  type        = string
}

variable "nat_name" {
  description = "The name of the Cloud NAT gateway."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network where the Cloud Router and NAT will reside."
  type        = string
}

variable "nat_ip_allocate_mode" {
  description = "How NAT IPs are allocated. Can be 'AUTO_ONLY' or 'MANUAL_ONLY'."
  type        = string
  default     = "AUTO_ONLY"
  validation {
    condition     = contains(["AUTO_ONLY", "MANUAL_ONLY"], var.nat_ip_allocate_mode)
    error_message = "nat_ip_allocate_mode must be 'AUTO_ONLY' or 'MANUAL_ONLY'."
  }

variable "nat_ips" {
  description = "List of specific NAT IP addresses to use if `nat_ip_allocate_mode` is `MANUAL_ONLY`. These should be existing external IP addresses."
  type        = list(string)
  default     = []
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How IP ranges in the subnets are NAT'ed. Can be 'ALL_SUBNETWORKS_ALL_IP_RANGES', 'ALL_SUBNETWORKS_AGGREGATE_IP_RANGES', or 'LIST_OF_SUBNETWORKS'."
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  validation {
    condition     = contains(["ALL_SUBNETWORKS_ALL_IP_RANGES", "ALL_SUBNETWORKS_AGGREGATE_IP_RANGES", "LIST_OF_SUBNETWORKS"], var.source_subnetwork_ip_ranges_to_nat)
    error_message = "source_subnetwork_ip_ranges_to_nat must be one of 'ALL_SUBNETWORKS_ALL_IP_RANGES', 'ALL_SUBNETWORKS_AGGREGATE_IP_RANGES', or 'LIST_OF_SUBNETWORKS'."
  }

variable "subnetworks_to_nat" {
  description = "List of subnetwork configurations for NAT. Required if `source_subnetwork_ip_ranges_to_nat` is `LIST_OF_SUBNETWORKS`."
  type = list(object({
    name                     = string
    source_ip_ranges_to_nat  = string # e.g., "ALL_IP_RANGES", "PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"
    secondary_ip_range_names = optional(list(string), [])
  }

variable "log_config_enable" {
  description = "Enable logging for Cloud NAT."
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Filter for logging. Can be 'ERRORS_ONLY', 'TRANSLATIONS_ONLY', or 'ALL'."
  type        = string
  default     = "ERRORS_ONLY"
  validation {
    condition     = contains(["ERRORS_ONLY", "TRANSLATIONS_ONLY", "ALL"], var.log_config_filter)
    error_message = "log_config_filter must be 'ERRORS_ONLY', 'TRANSLATIONS_ONLY', or 'ALL'."
  }
