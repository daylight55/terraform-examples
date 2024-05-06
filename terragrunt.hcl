locals {
  inputs = jsondecode(read_tfvars_file("${get_path_to_repo_root()}/terraform.tfvars"))
}

remote_state {
  backend = "gcs"
  config = {
    project = local.inputs.project
    bucket  = local.inputs.tfstate_bucket
    prefix  = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.8.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.27.0"
    }
  }
}

provider "google" {
  region                                        = "${local.inputs.region}"
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "PROACTIVE"
}
EOF
}

generate "remote_state" {
  path      = "_remote_state.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket  = "${local.inputs.tfstate_bucket}"
    prefix  = "vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket  = "${local.inputs.tfstate_bucket}"
    prefix  = "gke/terraform.tfstate"
  }
}
EOF
}

generate "locals" {
  path      = "_locals.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  project        = "${local.inputs.project}"
  region         = "${local.inputs.region}"
  tfstate_bucket = "${local.inputs.tfstate_bucket}"
}
EOF
}
