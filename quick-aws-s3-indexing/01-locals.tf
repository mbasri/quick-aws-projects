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

    "billing:organisation"      = "mbasri",
    "billing:organisation-unit" = "labs",
    "billing:application"       = "quick-aws-s3-indexing",
    "billing:environment"       = "dev",

    "security:compliance"     = "HIPAA",
    "security:data-sensitity" = "1",
    "security:encryption"     = "true",

    "technical:terraform"                     = "true",
    "technical:terraform:scm"                 = "https://github.com/mbasri/quick-aws-projects",
    "technical:terraform:required-version"    = "1.14.3",
    "technical:provider:aws:required-version" = "6.27.0"
  }
}
