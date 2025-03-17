output "cluster_id" {
  value = databricks_cluster.coldstart_sample.id
}

output "cluster_state" {
  value = databricks_cluster.coldstart_sample.state
}