// Forwarding rule for External Network Load Balancing using Backend Services
resource "google_compute_forwarding_rule" "http" {
  name                  = var.lb_config["loadbalancer"]
  region                = var.lb_config["region"]
  port_range            = var.lb_config["port_range"]
  backend_service       = google_compute_region_backend_service.backend.id
}
resource "google_compute_region_backend_service" "backend" {
  name                  = var.lb_config["backend"]
  region                = var.lb_config["region"]
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
}

resource "google_compute_region_health_check" "hc" {
  name               = var.lb_config["health_check"]
  check_interval_sec = 1
  timeout_sec        = 1
  region             = var.lb_config["region"]
  
  tcp_health_check {
    port = "80"
  }
}

# This block of code builds firewall for forwarding rule
resource "google_compute_firewall" "lb" {
  name    = var.lb_config["lb_firewall"]
  network = data.terraform_remote_state.vpcglobal.outputs.vpc_name
  allow {
    protocol = "tcp"
    ports    = var.lb_config["port_range"]
  }
#   source_tags   = [var.asg_config["network_tags"]]
  source_ranges = ["0.0.0.0/0"]
}