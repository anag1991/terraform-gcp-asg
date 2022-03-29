data "terraform_remote_state" "vpcglobal" {
  backend = "gcs"
  config = {
    bucket = "terraform-project-team3"
    prefix = "terraform/state/vpcglobal"
  }
}
output "vpcglobal" {
  value = data.terraform_remote_state.vpcglobal.outputs.vpcglobal
}

// Forwarding rule for External Network Load Balancing using Backend Services
resource "google_compute_forwarding_rule" "http" {
  name                  = var.lb_config["loadbalancer"]
  region                = var.lb_config["region"]
  port_range            = 80
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

# resource "google_compute_network" "default" {
#   name                    = "website-net"
#   auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "default" {
#   name          = "website-net"
#   ip_cidr_range = var.lb_config["ip_cidr_range"]
#   region        = var.lb_config["region"]
#   network       = google_compute_network.default.name
# }