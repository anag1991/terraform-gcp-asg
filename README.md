# ASG for GCP
> This project will create Auto Scaling Group for a Three-Tier application on GCP.

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Setup](#setup)
* [Usage](#usage)
* [Project Status](#project-status)
* [Room for Improvement](#room-for-improvement)
* [Inputs](#inputs)
* [Acknowledgements](#acknowledgements)
* [Contact](#contact)
<!-- * [License](#license) -->


## General Information
This repo create ASG that scales up upto 3 replicas, based on the LB traffic. There will be at least 1 instance that host wordpress website that has static IP.”


## Providers

| Name | Version |
| ----------- | ----------- |
| Terraform | v1.1.7 |
| Google Cloud SDK | 378.0.0 |



## Features
List the ready features here:
- Awesome feature 1
- Awesome feature 2
- Awesome feature 3


## Screenshots
![Example screenshot](./img/subnets.png)
<!-- We can add more screenshots here. -->


## Setup
What are the project requirements/dependencies? Where are they listed? A requirements.txt or a Pipfile.lock file perhaps? Where is it located?

Proceed to describe how to install / setup one's local environment / get started with the project.


## Usage
- This block of code builds auto scaler with the load balancer.

```
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
    hosts        = var.asg_config["static_name"] # Host = Static IP
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
```

## Project Status
Project is:  _complete_ 

## Room for Improvement
Include areas you believe need improvement / could be improved. Also add TODOs for future development.

Room for improvement:
- Improvement to be done 1
- Improvement to be done 2

To do:
- Feature to be added 1
- Feature to be added 2

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| asg_name | The name of the ASG |  | asg_config| yes |
| region | The GCP region where the managed instance group resides | string | Text | us-central1 | 
| autoscaler_name | Autoscaler name. When variable is empty, name will be derived from var.hostname.| string |  "team3-autoscaler" | 
| zone | The zone where the instanc group resides | string | "us-central1" | yes |
| target | URL of the managed instance group that autoscaler will scale|...| 0.5 |yes| 
| target-pool-name | The target load balancing pools to assign this group to | string | "team3-autoscaler" |
| min_replicas | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | yes |
| max_replicas | The minimum number of replicas that the autoscaler can scale down to | number | 5 | yes |
| cooldown_period | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance.| `number` | `60` | 

## Outputs
| Output      | Title | Description |
| ----------- | ----------- | ----------- |
| google_compute_autoscaler.asg.name     | asg_name     | The asg name  | 
| google_compute_autoscaler.asg.id    | asg_id     | The autoscaler id| 
| google_compute_instance_group_manager.group_manager.name      | igm_name   | The instance group manager name   | 
| google_compute_instance_group_manager.group_manager.id    |igm_id    | The instance group manager id |
| google_compute_instance_template.launch_template.name  | lt_name     | The launch template name  | 
| google_compute_instance_template.launch_template.id    | lt_id"     |The launch temaplate id  | 
| google_compute_target_pool.target_pool.name |  tp_name | The name of the target pool  |
| google_compute_target_pool.target_pool.id  | tp_id  |  The Id of the target pool  |
| google_compute_forwarding_rule.http.name  |   lb_name  |  The name of  the google compute forwarding rule |
| google_compute_forwarding_rule.http.id  |  lb_id  | Th    | The name of  the google compute forwarding rule |




## Acknowledgements
Give credit here.
- This project was inspired by Farukkh Sadykov
- This project was based on [this tutorial](https://www.example.com).
- Many thanks to Ana Ghirghilijiu, Jiyoung Chun, Tarik Allam, Tarik Sabir Idrissi, Akin Arslan

## Contact
Created by [@flynerdpl](https://www.flynerd.pl/) - feel free to contact me!


<!-- Optional -->
<!-- ## License -->
<!-- This project is open source and available under the [... License](). -->

<!-- You don't have to include all sections - just the one's relevant to your project -->
