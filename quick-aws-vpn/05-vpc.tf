#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------
module "vpc" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-vpc?ref=v1"

  vpc_name = local.vpc_name

  kms_arn = module.kms.key_arn

  enable_nat_gateway = true

  public_acl_ingress = {
    "100" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
    }
    "110" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
    }
    "999" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      cidr_block  = "0.0.0.0/0"
    }
  }

  public_acl_egress = {
    "100" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
    }
    "110" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
    }
    "999" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      cidr_block  = "0.0.0.0/0"
    }
  }

  private_acl_ingress = {
    "100" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      cidr_block  = "10.170.32.0/22"
    }
    "110" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      cidr_block  = "10.170.32.0/22"
    }
    "999" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      cidr_block  = "0.0.0.0/0"
    }
  }

  private_acl_egress = {
    "100" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
    }
    "110" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
    }
    "999" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      cidr_block  = "10.170.32.0/22"
    }
  }

  vpn_acl_ingress = {
    "999" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      cidr_block  = "0.0.0.0/0"
    }
  }

  vpn_acl_egress = {
    "100" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 53
      to_port     = 53
      cidr_block  = "0.0.0.0/0"
    }
    "110" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
    }
    "120" = {
      protocol    = "tcp"
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
    }
  }

  vpc_cidr            = "10.170.32.0/22"
  availability_zones  = ["eu-west-3a", "eu-west-3b"]
  public_subnet_cidr  = ["10.170.35.0/26", "10.170.35.64/26"]
  private_subnet_cidr = ["10.170.32.0/24", "10.170.33.0/24"]
  secure_subnet_cidr  = ["10.170.34.0/25", "10.170.34.128/25"]
  vpn_subnet_cidr     = ["10.170.35.192/27", "10.170.35.224/27"]
  spare_subnet_cidr   = []

  tags = local.tags
}
