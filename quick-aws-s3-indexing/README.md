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

### 2. Destroy infrastructure

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-s3-indexing
terraform init
terraform destroy
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