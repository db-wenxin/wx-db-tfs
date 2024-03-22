output "cluster_id" {
  value = databricks_cluster.coldstart.id
}

output "cluster_state" {
  value = databricks_cluster.coldstart.state
}