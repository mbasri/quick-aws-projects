#---------------------------------------------------------------------------------------------------
# SQS
#---------------------------------------------------------------------------------------------------
module "sqs" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-sqs?ref=v1.2.1"

  sqs_name    = local.sqs_name
  description = local.description

  kms_arn = module.kms.key_arn

  max_message_size = 1024 * 256

  message_retention_seconds  = 60 * 60 * 24 * 4
  visibility_timeout_seconds = 60 * 1
  receive_wait_time_seconds  = null

  source_dlq_config = {
    dlq_arn               = module.sqs-dlq.queue_arn
    dlq_max_receive_count = 10
  }

  policy = templatefile("${path.module}/policies.d/resources.d/sqs.json.tpl", {
    queue_arn  = module.sqs.queue_arn
    bucket_arn = module.s3.s3_bucket_arn
  })

  tags = local.tags
}

#---------------------------------------------------------------------------------------------------
# SQS DLQ
#---------------------------------------------------------------------------------------------------
module "sqs-dlq" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-sqs?ref=v1.2.1"

  sqs_name    = local.sqs_dlq_name
  description = local.description

  kms_arn = module.kms.key_arn

  max_message_size = 1024 * 256

  message_retention_seconds  = 60 * 60 * 24 * 14
  visibility_timeout_seconds = 60 * 60 * 12
  receive_wait_time_seconds  = null

  dlq_config = {
    sqs_arn = module.sqs.queue_arn
  }

  tags = local.tags
}
