terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }

#   backend "gcs" {
#     bucket = "demo-cours-devops-tf-state"
#   }

  required_version = ">= 1.0"
}


provider "google" {
    project = "devops-dauphine-psl"
}