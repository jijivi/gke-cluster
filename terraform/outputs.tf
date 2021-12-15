output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project" {
  value       = var.project
  description = "GCloud Project"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.default.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.default.endpoint
  description = "GKE Cluster Host"
}

output "endpoint" {
  value = google_container_cluster.default.endpoint
}

output "master_version" {
  value = google_container_cluster.default.master_version
}

# output "ingress_ip" {
#   value = google_compute_global_address.ingress_ip.address
# }
