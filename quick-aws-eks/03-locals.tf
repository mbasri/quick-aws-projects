#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-eks"
  region = "eu-west-3"

  description = "Quick AWS EKS"

  kms_name = local.name
  vpc_name = local.name
  eks_name = local.name

  tags = {
    "Name"        = local.name,
    "Description" = local.description,

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = "quick-aws-eks",
    "BillingEnvironment"      = "dev",

    "SecurityCompliance"      = "HIPAA",
    "SecurityDataSensitivity" = "1",
    "SecurityEncryption"      = "true",

    "TechnicalTerraform"                  = "true",
    "TechnicalTerraformSCM"               = "https://github.com/mbasri/quick-aws-projects",
    "TechnicalTerraformRequiredVersion"   = "1.14.3",
    "TechnicalProviderAWSRequiredVersion" = "6.31.0"
  }
}
