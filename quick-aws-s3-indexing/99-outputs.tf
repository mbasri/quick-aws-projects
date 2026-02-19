#---------------------------------------------------------------------------------------------------
# KMS
#---------------------------------------------------------------------------------------------------
output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.kms.key_arn
}

output "key_id" {
  description = "Name of the key"
  value       = module.kms.key_id
}

output "key_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = module.kms.key_alias_arn
}

output "key_alias_name" {
  description = "Name of the key alis"
  value       = module.kms.key_alias_name
}

output "key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.kms.key_policy
}

#---------------------------------------------------------------------------------------------------
# SQS
#---------------------------------------------------------------------------------------------------
output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs.queue_arn
}

output "queue_url" {
  description = "Same as `queue_id`: The URL for the created Amazon SQS queue"
  value       = module.sqs.queue_url
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = module.sqs.queue_name
}

#---------------------------------------------------------------------------------------------------
# SQS DLQ
#---------------------------------------------------------------------------------------------------
output "dlq_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs-dlq.queue_id
}

output "dlq_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs-dlq.queue_arn
}

output "dlq_url" {
  description = "Same as `queue_id`: The URL for the created Amazon SQS queue"
  value       = module.sqs-dlq.queue_url
}

output "dlq_name" {
  description = "The name of the SQS queue"
  value       = module.sqs-dlq.queue_name
}


#---------------------------------------------------------------------------------------------------
# S3
#---------------------------------------------------------------------------------------------------
output "s3_bucket_id" {
  description = "The name of the bucket"
  value       = module.s3.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = module.s3.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  value       = module.s3.s3_bucket_bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL"
  value       = module.s3.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.s3.s3_bucket_region
}

output "s3_bucket_regional_domain_name" {
  description = "Bucket regional name for CloudFront"
  value       = module.s3.s3_bucket_regional_domain_name
}
