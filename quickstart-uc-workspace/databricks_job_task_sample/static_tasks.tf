# Create a sample Multi-task job with sample notebooks
data "databricks_current_user" "this" {}
data "databricks_spark_version" "latest" {}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

# Create Sample Notebooks
resource "databricks_notebook" "sample_1" {
  source   = "${path.module}/src/sample_notebook1.py"
  path     = "/Shared/sample_notebook1"
  language = "PYTHON"
}
resource "databricks_notebook" "sample_2" {
  source   = "${path.module}/src/sample_notebook2.py"
  path     = "/Shared/sample_notebook2"
  language = "PYTHON"
}
resource "databricks_notebook" "sample_3" {
  source   = "${path.module}/src/sample_notebook3.py"
  path     = "/Shared/sample_notebook3"
  language = "PYTHON"
}

# Databricks Job
resource "databricks_job" "static_sample_job" {
  name = "Mutlti task job"
  job_cluster {
    job_cluster_key = "multi_task_job_cluster"
    new_cluster {
      num_workers = 1
      autoscale {
        min_workers = 1
        max_workers = 2
      }
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
      aws_attributes {
        first_on_demand = 1
      }
    }
  }

  schedule {
    # Execute the task every day at 7 AM (UTC time)
    quartz_cron_expression = "0 0 7 ? * * *"
    timezone_id            = "UTC"
  }

  task {
    task_key = "notebook-1"

    # job cluster for this task. This cluster is specifically
    # created for this job
    job_cluster_key = "multi_task_job_cluster"

    notebook_task {
      notebook_path = databricks_notebook.sample_1.id
    }
  }

  task {
    task_key = "notebook-2"
    # this task will only run after task 1
    depends_on {
      task_key = "notebook-1"
    }
    notebook_task {
      notebook_path = databricks_notebook.sample_2.id
    }
    job_cluster_key = "multi_task_job_cluster"
  }

  task {
    task_key = "notebook-3"
    # this task will only run after task 2
    depends_on {
      task_key = "notebook-2"
    }
    notebook_task {
      notebook_path = databricks_notebook.sample_3.id
    }
    job_cluster_key = "multi_task_job_cluster"
  }
}


resource "databricks_permissions" "sample_job_permission" {
  job_id = databricks_job.static_sample_job.id

  access_control {
    group_name       = "users"  #Use 'users' to grant permissions to all workspace users
    permission_level = "CAN_VIEW"
  }
}