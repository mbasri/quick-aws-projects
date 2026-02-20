#---------------------------------------------------------------------------------------------------
# Build Go & Create Zip
#---------------------------------------------------------------------------------------------------
resource "null_resource" "build" {
  triggers = {
    # main_go    = filesha256("${path.module}/src/main.go")
    # go_mod     = filesha256("${path.module}/src/go.mod")
    # go_sum     = filesha256("${path.module}/src/go.sum")
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.module}/src
      mkdir -p ../outputs.d
      GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go mod download
      GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o ../outputs.d/bootstrap main.go
      chmod 755 ../outputs.d/bootstrap
    EOT
  }
}

data "archive_file" "lambda" {
  type = "zip"

  source_file = "${path.module}/outputs.d/bootstrap"
  output_path = "${path.module}/outputs.d/lambda.zip"

  depends_on = [
    null_resource.build
  ]
}


#---------------------------------------------------------------------------------------------------
# Create custom policy for Lambda function to convert files to text via AWS Services
#---------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda" {
  name        = local.function_name
  description = local.description

  policy = templatefile("${path.module}/policies.d/iam.d/lambda.json.tpl", {
    kms_arn            = module.kms.key_arn
    s3_bucket_arn      = module.s3.s3_bucket_arn
    sqs_queue_arn      = module.sqs.queue_arn
    dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
  })

  tags = local.tags
}

#---------------------------------------------------------------------------------------------------
# Create Lambda function to convert files to text via AWS Services
#---------------------------------------------------------------------------------------------------
module "lambda" {
  #source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-lambda?ref=v2.3.0"
  source = "../../../mbasri-terraform-aws-modules/terraform-aws-lambda"

  function_name = local.function_name
  description   = local.description

  kms_key_arn = module.kms.key_arn

  handler = "bootstrap"
  runtime = "provided.al2023"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  timeout     = 30
  memory_size = 128

  environment_variables = {
    BUCKET_NAME    = module.s3.s3_bucket_id
    SQS_QUEUE_URL  = module.sqs.queue_url
    DYNAMODB_TABLE = module.dynamodb.dynamodb_table_id
  }

  policies_arn = [
    aws_iam_policy.lambda.arn
  ]

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
resource "aws_lambda_event_source_mapping" "sqs-trigger" {
  event_source_arn = module.sqs.queue_arn
  function_name    = module.lambda.lambda_function_arn
  batch_size       = 10
}
