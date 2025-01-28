# Create autopilo gke cluster 

# Create GKE Autopilot cluster
resource "google_container_cluster" "autopilot" {
  name     = "autopilot-cluster-1"
  location = "us-central1"

  enable_autopilot = true

  # Required for Autopilot
  release_channel {
    channel = "REGULAR"
  }

  # Network configuration
  network    = "default"
  subnetwork = "default"

}

# Deploy nginx using Helm
resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://helm.github.io/examples"
  chart      = "hello-world"

  # Wait for the cluster to be ready
  depends_on = [google_container_cluster.autopilot]

  # Custom values
  set {
    name  = "replicaCount"
    value = "2"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "80"
  }
}
