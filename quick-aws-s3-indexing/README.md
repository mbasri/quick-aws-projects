<!-- BEGIN_TF_DOCS -->
# Quick AWS EC2

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform project which create S3 linked to a SQS queue to index S3 objects metadata in the queue. The project also creates a Lambda function which is triggered by new messages in the SQS queue.

## *Create and destroy the infrastructure*

### 1. Create infrastructure

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-s3-indexing
terraform init
terraform apply
```

### 2. Test Lambda function (With sam cli)

```shell
mkdir -p tmp.d/events
SAM_CLI_TELEMETRY=0

sam local generate-event s3 put \
  --bucket my-bucket \
  --key my-folder/my-file.pdf > tmp.d/events/s3-event.json

sam local generate-event sqs receive-message\
  --body $(cat tmp.d/events/s3-event.json | jq -c . | sed 's/"/\\"/g') > tmp.d/events/sqs-event.json

sam local invoke --template-file ../sam-template.yaml \
  QuickAwsS3Indexing --profile lab -e ../tmp.d/events/sqs-event.json
```

### 3. Build and test Lambda function locally

```shell
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o ../tmp.d/bootstrap main.go; sam local invoke --template-file ../sam-template.yaml QuickAwsS3Indexing --profile lab -e ../tmp.d/events/sqs-event.json
```

### 4. Destroy infrastructure

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-s3-indexing
terraform init
terraform destroy
```

### 4. Build Go Lambda function locally

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-s3-indexing/src
go get github.com/aws/aws-lambda-go
go get github.com/aws/aws-sdk-go-v2/service/s3
go get github.com/aws/aws-sdk-go-v2/service/sqs
go get github.com/aws/aws-sdk-go-v2/service/dynamodb
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go mod download
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o ./bootstrap main.go
chmod 755 ./bootstrap

terraform apply -auto-approve; aws --profile lab s3 cp 00-versions.tf s3://quick-aws-s3-indexing
```

## *Generate docs*

```shell
terraform-docs -c .terraform-docs.yml .
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.27.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-kms | v1.4.1 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_alias_arn"></a> [key\_alias\_arn](#output\_key\_alias\_arn) | The Amazon Resource Name (ARN) of the key alias |
| <a name="output_key_alias_name"></a> [key\_alias\_name](#output\_key\_alias\_name) | Name of the key alis |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | The Amazon Resource Name (ARN) of the key |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | Name of the key |
| <a name="output_key_policy"></a> [key\_policy](#output\_key\_policy) | The IAM resource policy set on the key |

## *Author*

* [**Mohamed BASRI**](https://github.com/mbasri)

## *License*

This is free and unencumbered software released into the public domain - see the [LICENSE](./LICENSE) file for details

<!-- END_TF_DOCS -->