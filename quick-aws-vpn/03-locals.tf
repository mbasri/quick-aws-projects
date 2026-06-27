#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-vpn"
  region = "eu-west-3"

  description = "Quick AWS VPN"

  kms_name            = local.name
  vpc_name            = local.name
  security_group_name = local.name
  client_vpn_name     = local.name

  tags = {
    "Name"        = local.name,
    "Description" = "Quick AWS VPN",

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = "quick-aws-vpn",
    "BillingEnvironment"      = "dev",

    "SecurityCompliance"      = "HIPAA",
    "SecurityDataSensitivity" = "1",
    "SecurityEncryption"      = "true",

    "TechnicalTerraform"                  = "true",
    "TechnicalTerraformSCM"               = "https://github.com/mbasri/quick-aws-projects.git",
    "TechnicalTerraformRequiredVersion"   = "1.14.3",
    "TechnicalProviderAWSRequiredVersion" = "6.27.0"
  }
}
