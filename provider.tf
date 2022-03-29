provider "google" {
  project = data.terraform_remote_state.vpcglobal.outputs.project_id
  region  = var.asg_config["region"]
}
