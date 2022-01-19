resource "google_service_account" "gke_node" {
  account_id   = "gke-node"
  display_name = "Service Account"
}

resource "google_project_iam_binding" "artifact_registry_reader" {
  project = "k8-deploy-338617"
  role = "roles/artifactregistry.reader"

  members = [
    "serviceAccount:${google_service_account.gke_node.email}"
  ]
}

resource "google_container_cluster" "production" {
  name     = "production-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "pool_one" {
  name       = "pool-one"
  location   = "us-central1"
  cluster    = google_container_cluster.production.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_node.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
