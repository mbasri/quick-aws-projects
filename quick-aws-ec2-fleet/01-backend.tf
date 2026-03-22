#---------------------------------------------------------------------------------------------------
# Using multiple workspaces:
#---------------------------------------------------------------------------------------------------
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mbasri"

    workspaces {
      prefix = "quick-aws-ec2-fleet-"
    }
  }
}
