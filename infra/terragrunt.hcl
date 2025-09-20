terraform {
  source = "./terraform/data-lake"
}

locals {
  vars = yamldecode(file("${get_terragrunt_dir()}/inputs.yaml"))
}

inputs = local.vars
