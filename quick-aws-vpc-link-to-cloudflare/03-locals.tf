#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-vpc-link-to-cloudflare"
  region = "eu-west-3"

  description = "Quick AWS VPC Link to Cloudflare"

  vpc_cidr = "10.0.0.0/24"

  kms_name                  = local.name
  vpc_name                  = local.name
  security_group_name       = local.name
  iam_instance_profile_name = local.name
  instance_name             = local.name
  ssm_parameter_name        = local.name

  cloudflare_tunnel_name           = local.name
  cloudflare_tunnel_ssm_param_name = "${local.name}-tunnel-token"
  cloudflare_tunnel_iam_policy_name = "${local.iam_instance_profile_name}-tunnel-token"

  tags = {
    "Name"        = local.name,
    "Description" = local.description,

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = local.name,
    "BillingEnvironment"      = "dev",

    "SecurityCompliance"      = "HIPAA",
    "SecurityDataSensitivity" = "1",
    "SecurityEncryption"      = "true",

    "TechnicalTerraform"                    = "true",
    "TechnicalTerraformSCM"                 = "https://github.com/mbasri/quick-aws-projects",
    "TechnicalTerraformRequiredVersion"     = "1.14.3",
    "TechnicalProviderAWSRequiredVersion"        = "6",
    "TechnicalProviderCloudflareRequiredVersion" = "5",
    "TechnicalProviderRandomRequiredVersion"     = "3"
  }
}
