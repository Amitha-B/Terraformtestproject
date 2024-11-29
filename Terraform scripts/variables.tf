# variables.tf

# Define project variables
variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "node_count" {
  description = "Number of initial nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "deployment_name" {
  description = "Name of the Kubernetes deployment to autoscale"
  type        = string
  default     = "example-deployment"
}
