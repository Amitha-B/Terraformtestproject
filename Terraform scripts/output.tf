
# Output the GKE cluster name
output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.gke_cluster.name
}

# Output the endpoint for accessing the GKE cluster
output "cluster_endpoint" {
  description = "Endpoint for the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}

# Output the kubeconfig for connecting to the GKE cluster
output "kubeconfig" {
  description = "Kubeconfig for accessing the GKE cluster"
  value       = google_container_cluster.gke_cluster.kubeconfig_raw
}
