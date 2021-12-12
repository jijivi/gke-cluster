resource "google_container_cluster" "default" {
  provider    = google-beta
  name        = var.name
  project     = var.project
  description = "${var.name} GKE Cluster"
  location    = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  timeouts {
    create = "15m"
    update = "15m"
  }
}

resource "google_container_node_pool" "default" {
  provider   = google-beta
  name       = "${var.name}-node-pool"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.default.name
  node_count = 2
  autoscaling {
    max_node_count = 3
    min_node_count = 1
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }
  node_config {
    spot            = true
    machine_type    = var.machine_type
    disk_size_gb    = 35
    
    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = "github-actions@jijivi.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  timeouts {
    create = "15m"
    update = "15m"
  }
}
