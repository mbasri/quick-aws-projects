#---------------------------------------------------------------------------------------------------
# Terraform CHANGELOG : https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md
# Provider AWS CHANGELOG : https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md
# Provider Cloudflare CHANGELOG : https://github.com/cloudflare/terraform-provider-cloudflare/blob/master/CHANGELOG.md
#---------------------------------------------------------------------------------------------------
terraform {
  required_version = "1.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}