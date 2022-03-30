# This module builds Global Http Forwarding Rule
resource "google_compute_global_forwarding_rule" "lb" {
  name       = var.lb_config["loadbalancer"]
  target     = google_compute_target_http_proxy.target_proxy.id
  port_range = var.lb_config["port_range"]
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name        = var.lb_config["target_proxy"]
  url_map     = google_compute_url_map.url_map.id
}

resource "google_compute_url_map" "url_map" {
  name            = var.lb_config["url_map"]
  default_service = google_compute_backend_service.backend.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backend.id
    }
  }
}

resource "google_compute_backend_service" "backend" {
  name        = var.lb_config["backend"]
  port_name   = var.lb_config["port_name"]
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.hc.id]
}

resource "google_compute_http_health_check" "hc" {
  name               = var.lb_config["health_check"]
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}