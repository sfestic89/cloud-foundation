resource "google_cloud_run_v2_service" "cloud_run" {
  for_each = var.cloud_run_services

  project             = each.value.project
  name                = each.value.name
  location            = each.value.region
  deletion_protection = each.value.deletion_protection
  ingress             = each.value.ingress

  template {
    containers {
      image = each.value.image

      ports {
        container_port = each.value.port
      }

      dynamic "env" {
        for_each = each.value.env_variables
        content {
          name  = env.key
          value = env.value
        }
      }

      resources {
        limits = {
          cpu    = each.value.cpu
          memory = each.value.memory
        }
      }
    }
  }

  scaling {
    min_instance_count = each.value.min_instance_count
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  for_each = { for k, v in var.cloud_run_services : k => v if v.allow_unauthenticated }

  service  = google_cloud_run_v2_service.cloud_run[each.key].name
  location = google_cloud_run_v2_service.cloud_run[each.key].location
  project  = google_cloud_run_v2_service.cloud_run[each.key].project
  role     = "roles/run.invoker"
  member   = "allUsers"
}