#---------------------------------------------------------------------------------------------------
# Client VPN
#---------------------------------------------------------------------------------------------------
module "client-vpn" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-client-vpn?ref=v1.3.1"

  description = local.description

  kms_arn = module.kms.key_alias_arn

  client_vpn_name = local.client_vpn_name

  vpc_id     = module.vpc.vpc_id
  subnets_id = module.vpc.vpn_subnet_ids
  security_group_ids = [
    module.security-group.security_group_id
  ]

  client_cidr         = "10.10.0.0/20"
  self_service_portal = "enabled"

  server_certificate_arn     = data.aws_acm_certificate.server.arn
  root_certificate_chain_arn = data.aws_acm_certificate.client.arn

  tags = local.tags
}
