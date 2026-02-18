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
