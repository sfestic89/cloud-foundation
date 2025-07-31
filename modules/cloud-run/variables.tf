variable "cloud_run_services" {
  description = "Map of Cloud Run services to deploy"
  type = map(object({
    name                  = string
    project               = string
    region                = string
    image                 = string
    port                  = optional(number, 8080)
    env_variables         = optional(map(string), {})
    cpu                   = optional(string, "1")
    memory                = optional(string, "512Mi")
    deletion_protection   = optional(bool, false)
    ingress               = optional(string, "INGRESS_TRAFFIC_ALL")
    min_instance_count    = optional(number, 0)
    allow_unauthenticated = optional(bool, false)
  }))
}