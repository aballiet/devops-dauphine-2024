terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = "VOTRE_PROJET_GCP" # TODO: REMPLACER PAR SON PROJET GCP
  region  = "us-central1"
}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.autopilot.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.autopilot.master_auth[0].cluster_ca_certificate)
  }
}

data "google_client_config" "default" {}
