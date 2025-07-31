output "cloud_run_service_names" {
  description = "Cloud Run service names"
  value = {
    for k, s in google_cloud_run_v2_service.cloud_run :
    k => s.name
  }
}

output "cloud_run_service_urls" {
  description = "Cloud Run service URLs"
  value = {
    for k, s in google_cloud_run_v2_service.cloud_run :
    k => s.uri
  }
}