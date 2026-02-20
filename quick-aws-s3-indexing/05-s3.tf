#---------------------------------------------------------------------------------------------------
# S3
#---------------------------------------------------------------------------------------------------
module "s3" {
  source      = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-s3?ref=v1.4.2"
  bucket_name = local.bucket_name

  kms_arn = module.kms.key_arn

  # REMOVE IN PROD ENVIRONMENT
  force_destroy = true

  lifecycle_rules = [
    {
      id      = "standard-ia-and-expiration"
      enabled = true
      transition = [
        {
          days          = 30,
          storage_class = "STANDARD_IA"
        }
      ]
      noncurrent_version_transition = [
        {
          days          = 30,
          storage_class = "STANDARD_IA"
        }
      ]
      noncurrent_version_expiration = {
        days = 90
      }
      expiration = {
        days = 90
      }
      abort_incomplete_multipart_upload_days = 30
    }
  ]

  tags = local.tags
}


#---------------------------------------------------------------------------------------------------
# Create notification for new files in S3 bucket
#---------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_notification" "object-created" {
  bucket = module.s3.s3_bucket_id

  queue {
    id        = "object-created-to-sqs"
    queue_arn = module.sqs.queue_arn
    events    = ["s3:ObjectCreated:*"]
    #filter_prefix = ""
  }

  depends_on = [
    module.sqs
  ]
}