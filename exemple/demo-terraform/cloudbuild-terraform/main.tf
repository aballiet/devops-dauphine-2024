resource "google_project_service" "ressource_manager" {
    service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "ressource_usage" {
    for_each = toset(["serviceusage.googleapis.com"])
    service = "serviceusage.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_project_service" "artifact" {
    service = "artifactregistry.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_artifact_registry_repository" "demo-repo" {
  location      = "us-central1"
  repository_id = "demo-repository"
  description   = "Exemple de repo Docker"
  format        = "DOCKER"

  depends_on = [ google_project_service.artifact ]
}

# ATTENTION : A changer: le nom doit être unique !
# resource "google_storage_bucket" "default" {
#     name          = "testbucket-dauphine-devops" 
#     location      = "US"
#     force_destroy = true
# }