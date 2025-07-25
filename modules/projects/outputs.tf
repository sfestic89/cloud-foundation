output "project_ids" {
  value = {
    for key, project in google_project.this :
    key => project.project_id
  }
}

output "project_names" {
  description = "Map of project resource names"
  value       = { for k, v in google_project.this : k => v.name }
}

output "project_numbers" {
  value = {
    for k, p in google_project.this :
    k => p.number
  }
}