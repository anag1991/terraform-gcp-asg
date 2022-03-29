resource "google_compute_target_pool" "target_pool" {
  region = var.asg_config["region"]
  name   = var.asg_config["target-pool-name"]
}

# This block of code builds auto scaler
resource "google_compute_autoscaler" "asg" {
  zone = var.asg_config["zone"]
  name = var.asg_config["autoscaler"]

  target = google_compute_instance_group_manager.group_manager.id

  autoscaling_policy {
    max_replicas    = var.asg_config["max_replicas"]
    min_replicas    = var.asg_config["min_replicas"]
    cooldown_period = var.asg_config["cooldown_period"]
    cpu_utilization {
      target = var.asg_config["target"]
    }
  }
}

# IGM is a collectoin of instances that you can manage as a single entity
# This block of code attaches igm to the target pool

resource "google_compute_instance_group_manager" "group_manager" {
  zone = var.asg_config["zone"]
  name = var.asg_config["instance_group_manager_name"]
  version {
    instance_template = google_compute_instance_template.launch_template.id
    name              = "primary"
  }
  target_pools       = [google_compute_target_pool.target_pool.self_link]
  base_instance_name = var.asg_config["base_instance_name"]
}
