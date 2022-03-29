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

resource "google_compute_forwarding_rule" "lb" {
  name                  = var.lb_config["loadbalancer"]
  region                = var.lb_config["region"]
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  all_ports             = true
  allow_global_access   = true

  ## switch below before merge

  network = google_compute_network.default.name
  # network             = data.terraform_remote_state.vpc.outputs.vpc_name

  subnetwork = google_compute_subnetwork.default.name
  # network             = data.terraform_remote_state.vpc.outputs.NEED_THIS_FROM_TEAM_VPC
}


resource "google_compute_region_backend_service" "backend" {
  name          = var.lb_config["backend"]
  region        = var.lb_config["region"]
  health_checks = [google_compute_health_check.hc.id]
}

resource "google_compute_health_check" "hc" {
  name               = var.lb_config["health_check"]
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

// Forwarding rule for External Network Load Balancing using Backend Services
resource "google_compute_forwarding_rule" "default" {
  provider              = google-beta
  name                  = "website-forwarding-rule"
  region                = "us-central1"
  port_range            = 80
  backend_service       = google_compute_region_backend_service.backend.id
}
resource "google_compute_region_backend_service" "backend" {
  provider              = google-beta
  name                  = "website-backend"
  region                = "us-central1"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
}
resource "google_compute_region_health_check" "hc" {
  provider           = google-beta
  name               = "check-website-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  region             = "us-central1"

  tcp_health_check {
    port = "80"
  }
}