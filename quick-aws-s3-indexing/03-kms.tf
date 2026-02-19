#---------------------------------------------------------------------------------------------------
# KMS
#---------------------------------------------------------------------------------------------------
module "kms" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-kms?ref=v1.4.1"

  kms_name                = local.kms_name
  description             = local.description
  enable_cloudwatch_logs  = true
  enable_s3               = true
  deletion_window_in_days = 7

  tags = local.tags
}
