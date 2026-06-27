#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-ec2"
  region = "eu-west-3"

  description = "Quick AWS EC2"

  kms_name                  = local.name
  vpc_name                  = local.name
  security_group_name       = local.name
  iam_instance_profile_name = local.name
  instance_name             = local.name
  ssm_parameter_name        = local.name

  tags = {
    "Name"        = local.name,
    "Description" = "Quick AWS EC2",

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = "quick-aws-ec2",
    "BillingEnvironment"      = "dev",

    "SecurityCompliance"      = "HIPAA",
    "SecurityDataSensitivity" = "1",
    "SecurityEncryption"      = "true",

    "TechnicalTerraform"                  = "true",
    "TechnicalTerraformSCM"               = "https://github.com/mbasri/quick-aws-projects",
    "TechnicalTerraformRequiredVersion"   = "1.14.3",
    "TechnicalProviderAWSRequiredVersion" = "6.27.0"
  }
}
