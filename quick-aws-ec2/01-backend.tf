#---------------------------------------------------------------------------------------------------
# Terraform backend configuration for remote state management using Terraform Cloud
#---------------------------------------------------------------------------------------------------
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mbasri"

    workspaces {
      prefix = "quick-aws-ec2-"
    }
  }
}
