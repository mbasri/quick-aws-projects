#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-ec2-fleet"
  region = "eu-west-3"

  description = "Quick AWS EC2 Fleet"

  kms_name                  = local.name
  vpc_name                  = local.name
  security_group_name       = local.name
  iam_instance_profile_name = local.name
  autoscaling_name          = local.name
  ssm_parameter_name        = local.name
  target_group_name         = local.name
  alb_name                  = local.name

  tags = {
    "Name"        = local.name,
    "Description" = "Quick AWS EC2 Fleet",

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = "quick-aws-ec2-fleet",
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
