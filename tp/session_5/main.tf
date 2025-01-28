# Create autopilo gke cluster 

# Create GKE Autopilot cluster
# Define a Google GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "gke-cluster"

  # Basic cluster settings
  initial_node_count = 1 # This sets the default number of nodes in the default node pool
  remove_default_node_pool = true # Remove the default node pool as we define a custom one below

  # Network settings
  network    = "default" # Default VPC network
  subnetwork = "default" # Default subnet in the VPC network
}

# Define a custom node pool with a single node
resource "google_container_node_pool" "default_pool" {
  cluster    = google_container_cluster.gke_cluster.name
  location   = google_container_cluster.gke_cluster.location
  name       = "default-node-pool"

  node_count = 1 # Single node

  node_config {
    machine_type = "e2-medium" # Choose the machine type for the nodes
    preemptible  = false       # If true, nodes will be preemptible (optional)
  }
}

# Deploy nginx using Helm
resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://helm.github.io/examples"
  chart      = "hello-world"

  # Wait for the cluster to be ready
  depends_on = [google_container_cluster.gke_cluster]

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
