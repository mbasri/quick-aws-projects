#---------------------------------------------------------------------------------------------------
# Create custom policy for Lambda function to convert files to text via AWS Services
#---------------------------------------------------------------------------------------------------
# resource "aws_iam_policy" "lambda-indexing" {
#   name        = local.iam_policy_name["lambda-indexing"]
#   description = "[Terraform] Policy for Lambda function to access DynamoDB, S3 and SQS resources"

#   policy = templatefile("${path.module}/policies.d/iam/lambda-indexing.json.tpl", {
#     kms_arn            = module.kms.key_arn
#     s3_bucket_arn      = module.s3.s3_bucket_arn
#     sqs_queue_arn      = module.sqs-object-created.queue_arn
#     dynamodb_table_arn = module.dynamodb-documents.dynamodb_table_arn
#   })

#   tags = local.tags
# }

#---------------------------------------------------------------------------------------------------
# Create Lambda function to convert files to text via AWS Services
#---------------------------------------------------------------------------------------------------
module "lambda" {
  #source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-lambda?ref=v2.2.1"
  source = "../../../mbasri-terraform-aws-modules/terraform-aws-lambda"

  function_name = local.function_name
  description   = local.description

  kms_key_arn = module.kms.key_arn

  handler = "bootstrap"
  runtime = "provided.al2023"

  filename = "test.zip"

  timeout     = 30
  memory_size = 128

  environment_variables = {
    S3_BUCKET_NAME               = module.s3.s3_bucket_id
    SQS_OBJECT_CREATED_QUEUE_URL = module.sqs.queue_url
    DYNAMODB_DOCUMENTS_TABLE     = module.dynamodb.dynamodb_table_id
  }

  # policies_arn = [
  #   aws_iam_policy.lambda-indexing.arn
  # ]

  #source_path = "${path.module}/lambdas.d/main"

  # layers = [
  #   module.layer-libs.lambda_layer_arn,
  #   module.layer-utils.lambda_layer_arn
  # ]

  tags = local.tags
}

#---------------------------------------------------------------------------------------------------
# Create mapping between SQS queue and Lambda function to convert files to text via AWS Services
#---------------------------------------------------------------------------------------------------
# resource "aws_lambda_event_source_mapping" "sqs-trigger" {
#   event_source_arn = module.sqs.queue_arn
#   function_name    = module.lambda.lambda_function_arn
#   batch_size       = 10
# }
