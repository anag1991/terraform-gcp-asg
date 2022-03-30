output "asg_name" {
  value = google_compute_autoscaler.asg.name
}
output "asg_id" {
  value = google_compute_autoscaler.asg.id
}

output "igm_name" {
  value = google_compute_instance_group_manager.group_manager.name
}
output "igm_id" {
  value = google_compute_instance_group_manager.group_manager.id
}

output "lt_name" {
  value = google_compute_instance_template.launch_template.name
}
output "lt_id" {
  value = google_compute_instance_template.launch_template.id
}

output "tp_name" {
  value = google_compute_target_pool.target_pool.name
}
output "tp_id" {
  value = google_compute_target_pool.target_pool.id
}

output "lb_name" {
  value = google_compute_global_forwarding_rule.http.name
}
output "lb_id" {
  value = google_compute_global_forwarding_rule.http.id
}