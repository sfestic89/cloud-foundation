output "folder_ids" {
  description = "Map of folder display names to their resource names"
  value = {
    for name, folder in google_folder.folders :
    name => folder.name
  }
}