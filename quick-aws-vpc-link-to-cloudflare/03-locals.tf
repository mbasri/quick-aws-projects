#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-vpc-link-to-cloudflare"
  region = "eu-west-3"

  description = "Quick AWS VPC Link to Cloudflare"

  kms_name                  = local.name
  vpc_name                  = local.name
  security_group_name       = local.name
  iam_instance_profile_name = local.name
  instance_name             = local.name
  ssm_parameter_name        = local.name

  tags = {
    "Name"        = local.name,
    "Description" = local.description,

    "billing:organisation"      = "mbasri",
    "billing:organisation-unit" = "labs",
    "billing:application"       = local.name,
    "billing:environment"       = "dev",

    "security:compliance"       = "HIPAA",
    "security:data-sensitivity" = "1",
    "security:encryption"       = "true",

    "technical:terraform"                     = "true",
    "technical:terraform:scm"                 = "https://github.com/mbasri/quick-aws-projects",
    "technical:terraform:required-version"    = "1.14.3",
    "technical:provider:aws:required-version" = "6.27.0"
  }
}
