#---------------------------------------------------------------------------------------------------
# Security Group
#---------------------------------------------------------------------------------------------------
module "security-group" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-security-group?ref=v1.3.1"

  vpc_id = module.vpc.vpc_id

  security_group_name = local.security_group_name
  description         = local.description

  egress_rules = [
    {
      ip_protocol = "tcp"
      from_port   = "80"
      to_port     = "80"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] HTTP for all IP"
    },
    {
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] HTTPS for all IP"
    }
  ]

  tags = local.tags
}
