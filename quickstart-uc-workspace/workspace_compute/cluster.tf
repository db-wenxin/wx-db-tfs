data "databricks_node_type" "smallest" {
  provider   = databricks.workspace
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  provider          = databricks.workspace
  long_term_support = true
}

resource "databricks_cluster" "coldstart_sample" {
  provider                = databricks.workspace
  cluster_name            = "cluster - example"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 30
  autoscale {
    min_workers = 1
    max_workers = 1
  }
  spark_conf = {
    "spark.databricks.repl.allowedLanguages" : "python,sql",
  }
  spark_env_vars = {
    "Env_1"              = "value_1",
    "Env_2"              = "value_2",
    "AWS_DEFAULT_REGION" = "us-east-1",
  }
  custom_tags = {
    "example_tag" = "sample_tag"
  }
}