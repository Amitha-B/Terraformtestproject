# main.tf

# Specify the Terraform provider
provider "google" {
  project = var.project_id  # Google Cloud project ID
  region  = var.region      # Region where GKE will be deployed
}


# Create a custom VPC
resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false  # Disable auto-creation of subnets
}

# Create a custom subnet within the VPC
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-subnet"
  region        = var.region               # Region for the subnet
  network       = google_compute_network.custom_vpc.id
  ip_cidr_range = "10.0.0.0/16"                # IP range for the subnet
}




# Enable the Kubernetes Engine API
resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
}

# Create the GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name          # Name of the GKE cluster
  location = var.region                # Regional cluster for high availability
  network  = google_compute_network.custom_vpc.id
  subnetwork = google_compute_subnetwork.custom_subnet.id
  initial_node_count = 1               # Initial node count (required but overridden by node pool)

  # Node pool configuration
  node_pool {
    name = "default-pool"

    # Autoscaling settings
    autoscaling {
      enabled        = true
      min_node_count = 2               # Minimum nodes
      max_node_count = 5               # Maximum nodes
    }

    # Node configuration
    node_config {
      machine_type = var.machine_type  # Instance type
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }

  # Enable monitoring and logging
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"
}

# Kubernetes Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler" "hpa" {
  metadata {
    name      = "cpu-autoscaler"
    namespace = "default"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = var.deployment_name       # Deployment to scale
      api_version = "apps/v1"
    }

    min_replicas = 1                   # Minimum number of pods
    max_replicas = 5                   # Maximum number of pods

    # CPU utilization threshold
    metrics {
      type = "Resource"
      resource {
        name = "cpu"
        target_average_utilization = 70  # Scale at 70% CPU usage
      }
    }
  }
}
