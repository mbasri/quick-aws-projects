#---------------------------------------------------------------------------------------------------
# locals variables
#---------------------------------------------------------------------------------------------------
locals {
  name   = "quick-aws-s3-indexing"
  region = "eu-west-3"

  description = "Quick AWS S3 Indexing"

  kms_name            = local.name
  sqs_name            = local.name
  sqs_dlq_name        = "${local.name}-dlq"
  bucket_name         = local.name
  dynamodb_table_name = local.name
  function_name       = local.name

  tags = {
    "Name"        = local.name,
    "Description" = "Quick AWS S3 Indexing",

    "BillingOrganisation"     = "mbasri",
    "BillingOrganisationUnit" = "labs",
    "BillingApplication"      = "quick-aws-s3-indexing",
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
