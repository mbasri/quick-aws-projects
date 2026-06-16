#---------------------------------------------------------------------------------------------------
# Security Group
#---------------------------------------------------------------------------------------------------
module "security-group" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-security-group?ref=v1"

  vpc_id = module.vpc.vpc_id

  security_group_name = local.security_group_name
  description         = local.description

  ingress_rules = [
    {
      ip_protocol = "tcp"
      from_port   = "80"
      to_port     = "80"
      cidr_ipv4   = "10.0.0.0/24"
      description = "[Terraform] HTTP for instance info page"
    }
  ]

  egress_rules = [
    {
      ip_protocol = "tcp"
      from_port   = "80"
      to_port     = "80"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] HTTP for Internet"
    },
    {
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] HTTPS for Internet"
    },
    {
      ip_protocol = "tcp"
      from_port   = "7844"
      to_port     = "7844"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] Cloudflare Tunnel HTTP2 protocol"
    },
    {
      ip_protocol = "udp"
      from_port   = "7844"
      to_port     = "7844"
      cidr_ipv4   = "0.0.0.0/0"
      description = "[Terraform] Cloudflare Tunnel QUIC protocol"
    }
  ]

  tags = local.tags
}
