terraform {
  backend "gcs" {
    bucket = "terraform-project-team3"
    prefix = "terraform/state/asg"
  }
}
