# variables for auto scaler
variable "asg_config" {
  type = map(any)
  default = {
    region                      = "us-central1"
    zone                        = "us-central1-c"
    target-pool-name            = "team3-target-pool"
    autoscaler                  = "team3-autoscaler"
    max_replicas                = 5
    min_replicas                = 1
    cooldown_period             = 60
    target                      = 0.5
    instance_group_manager_name = "team3-igm"
    instance_template_name      = "team3-instance-template"
    machine_type                = "e2-medium"
    source_image                = "centos-cloud/centos-7"
    base_instance_name          = "team3-base-instance"
    firewall_name               = "wordpress"
    network_tags                = "wordpress"
    static_name                 = "ipv4-address"
  }
}

# variables for forwaring rule
variable "lb_config" {
  type = map(any)
  default = {
    region           = "us-central1"
    zone             = "us-central1-c"
    target-pool-name = "team3-target-pool"
    loadbalancer     = "team3-loadbalancer"
    port_range       = "80, 443, 22"
    backend          = "website-backend"
    health_check     = "check-website-backend"
    ip_cidr_range    = "10.0.0.0/16"
    lb_firewall      = "lb-firewall"
  }
}
