#---------------------------------------------------------------------------------------------------
# DynamoDB
#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------
# Create DynamoDB to store status of files to be converted to text
#---------------------------------------------------------------------------------------------------
module "dynamodb" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-dynamodb?ref=v1.3.1"

  dynamodb_table_name = local.dynamodb_table_name
  description         = local.description

  kms_key_arn = module.kms.key_arn

  attributes = [
    {
      name = "objectKey"
      type = "S"
    },
    {
      name = "objectSize"
      type = "N"
    },
    {
      name = "objectTimestamp"
      type = "S"
    },
    {
      name = "lastUpdate"
      type = "S"
    }
  ]

  local_secondary_indexes = [
    {
      name               = "objectTimestampIndex"
      range_key          = "objectTimestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["objectKey"]
    },
    {
      name               = "lastUpdateIndex"
      range_key          = "lastUpdate"
      projection_type    = "ALL"
      non_key_attributes = []
    }
  ]

  hash_key  = "objectKey"
  range_key = "objectSize"

  tags = local.tags
}
