<!-- BEGIN_TF_DOCS -->
# Quick AWS VPC Link to Cloudflare

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform project which creates a VPC and an EC2 instance running [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) to expose private AWS resources through Cloudflare without opening any inbound port.

## *Network flows*

> **Note:** cloudflared connects outbound on UDP 7844 (QUIC, preferred) and falls back to TCP 443. See [Cloudflare Tunnel firewall requirements](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deploy-tunnels/tunnel-with-firewall/).

## *Create and destroy the infrastructure*

### 0. Prerequisites

Configure the AWS profile:

```shell
aws configure --profile lab
```

Set the AWS profile for local usage:

```shell
export AWS_PROFILE=lab
```

Log in to Terraform Cloud:

```shell
terraform login
```

Configure the Cloudflare credentials — create `~/.cloudflare/.env` if it does not exist yet:

```shell
mkdir -p ~/.cloudflare
cat > ~/.cloudflare/.env << 'EOF'
export CLOUDFLARE_API_TOKEN="<your_api_token>"
export TF_VAR_cloudflare_account_id="<your_account_id>"
EOF
chmod 600 ~/.cloudflare/.env
```

> **How to get these values:**
> - `CLOUDFLARE_API_TOKEN` → Cloudflare dashboard > My Profile > API Tokens > Create Token with the following permissions:
>   - `Cloudflare Tunnel` : `Edit`
>   - `Account Settings` : `Read`
> - `TF_VAR_cloudflare_account_id` → visible in the Cloudflare dashboard URL: `https://dash.cloudflare.com/<account_id>/...`

Source the credentials before running Terraform:

```shell
source ~/.cloudflare/.env
```

### 1. Create infrastructure

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-projects/quick-aws-vpc-link-to-cloudflare
terraform workspace new quick-aws-vpc-link-to-cloudflare-dev 2>/dev/null
terraform workspace select quick-aws-vpc-link-to-cloudflare-dev
terraform init
terraform apply
```

### 2. Destroy infrastructure

```shell
git clone https://github.com/mbasri/quick-aws-projects.git
cd quick-aws-projects/quick-aws-vpc-link-to-cloudflare
terraform workspace new quick-aws-vpc-link-to-cloudflare-dev 2>/dev/null
terraform workspace select quick-aws-vpc-link-to-cloudflare-dev
terraform init
terraform destroy
```

## *Use the EC2 instance*

### 1. Connect to the EC2 instance

```shell
aws --profile lab --region eu-west-3 ssm start-session --target $(aws --profile lab --region eu-west-3 ec2 describe-instances --filters "Name=tag:Name,Values=quick-aws-vpc-link-to-cloudflare" "Name=instance-state-name,Values=running" --query "Reservations[0].Instances[0].InstanceId" --output text)
```

### 2. Run a proxy server

```shell
chmod +x run-proxy
./run-proxy
```

## *Generate docs*

```shell
terraform-docs -c .terraform-docs.yml .
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.21.1 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.4.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.9.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-ec2 | v1 |
| <a name="module_iam-instance-profile"></a> [iam-instance-profile](#module\_iam-instance-profile) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-iam-instance-profile | v1 |
| <a name="module_kms"></a> [kms](#module\_kms) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-kms | v1 |
| <a name="module_security-group"></a> [security-group](#module\_security-group) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-security-group | v1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-vpc | v1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cloudflare-tunnel-token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_ssm_parameter.cloudflare-tunnel-token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cloudwatch-agent-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared_route.vpc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_route) | resource |
| [local_file.run-proxy](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.tunnel_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [cloudflare_zero_trust_tunnel_cloudflared_token.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zero_trust_tunnel_cloudflared_token) | data source |
| [cloudinit_config.main](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | Cloudflare Account ID — see README Prerequisites section for how to set this value | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudflare_tunnel_cname"></a> [cloudflare\_tunnel\_cname](#output\_cloudflare\_tunnel\_cname) | Tunnel CNAME — add a CNAME DNS record pointing to this value to route traffic |
| <a name="output_cloudflare_tunnel_id"></a> [cloudflare\_tunnel\_id](#output\_cloudflare\_tunnel\_id) | The ID of the Cloudflare tunnel |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the VPC default security group |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | The ARN of the IAM Instance Profile |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | The ID of the IAM Instance Profile |
| <a name="output_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#output\_iam\_instance\_profile\_name) | The Name of the IAM Instance Profile |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | The Instance ARN |
| <a name="output_instance_availability_zone"></a> [instance\_availability\_zone](#output\_instance\_availability\_zone) | The availability zone of the created instance |
| <a name="output_instance_ebs_block_device_volume_ids"></a> [instance\_ebs\_block\_device\_volume\_ids](#output\_instance\_ebs\_block\_device\_volume\_ids) | Block devices IDs |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The Instance ID |
| <a name="output_instance_instance_state"></a> [instance\_instance\_state](#output\_instance\_instance\_state) | The state of the instance |
| <a name="output_instance_key_name"></a> [instance\_key\_name](#output\_instance\_key\_name) | The Key used by the Instance |
| <a name="output_instance_lifecycle"></a> [instance\_lifecycle](#output\_instance\_lifecycle) | Indicates whether this is a Spot Instance or a Scheduled Instance |
| <a name="output_instance_primary_network_interface_id"></a> [instance\_primary\_network\_interface\_id](#output\_instance\_primary\_network\_interface\_id) | The ID of the instance's primary network interface |
| <a name="output_instance_private_dns"></a> [instance\_private\_dns](#output\_instance\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | The private IP address assigned to the instance |
| <a name="output_instance_root_block_device_volume_ids"></a> [instance\_root\_block\_device\_volume\_ids](#output\_instance\_root\_block\_device\_volume\_ids) | Root EBS IDs |
| <a name="output_instance_spot_request_id"></a> [instance\_spot\_request\_id](#output\_instance\_spot\_request\_id) | If the request is a Spot Instance request, the ID of the request |
| <a name="output_instance_subnet_id"></a> [instance\_subnet\_id](#output\_instance\_subnet\_id) | Subnet used by the instance |
| <a name="output_instance_vpc_security_group_ids"></a> [instance\_vpc\_security\_group\_ids](#output\_instance\_vpc\_security\_group\_ids) | List of security group used by the instance |
| <a name="output_key_alias_arn"></a> [key\_alias\_arn](#output\_key\_alias\_arn) | The Amazon Resource Name (ARN) of the key alias |
| <a name="output_key_alias_name"></a> [key\_alias\_name](#output\_key\_alias\_name) | Name of the key alias |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | The Amazon Resource Name (ARN) of the key |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The ID of the key |
| <a name="output_key_policy"></a> [key\_policy](#output\_key\_policy) | The IAM resource policy set on the key |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | Public IP of NAT Gateway |
| <a name="output_private_subnet_cidr"></a> [private\_subnet\_cidr](#output\_private\_subnet\_cidr) | List of cidr\_blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_public_subnet_cidr"></a> [public\_subnet\_cidr](#output\_public\_subnet\_cidr) | List of cidr\_blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_region"></a> [region](#output\_region) | The Name of the region |
| <a name="output_secure_subnet_cidr"></a> [secure\_subnet\_cidr](#output\_secure\_subnet\_cidr) | List of cidr\_blocks of secure subnets |
| <a name="output_secure_subnet_ids"></a> [secure\_subnet\_ids](#output\_secure\_subnet\_ids) | List of IDs of secure subnets |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the security group |
| <a name="output_security_group_description"></a> [security\_group\_description](#output\_security\_group\_description) | The description of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the security group |
| <a name="output_security_group_owner_id"></a> [security\_group\_owner\_id](#output\_security\_group\_owner\_id) | The owner ID |
| <a name="output_security_group_vpc_id"></a> [security\_group\_vpc\_id](#output\_security\_group\_vpc\_id) | The VPC ID |
| <a name="output_spot_logs_cwl_id"></a> [spot\_logs\_cwl\_id](#output\_spot\_logs\_cwl\_id) | The IDs of the cloudwatch logs for Spot logging |
| <a name="output_ssh_start_socks_v5_proxy"></a> [ssh\_start\_socks\_v5\_proxy](#output\_ssh\_start\_socks\_v5\_proxy) | Command to start socks v5 proxy |
| <a name="output_ssm_copy_ssh_key"></a> [ssm\_copy\_ssh\_key](#output\_ssm\_copy\_ssh\_key) | Command to copy ssh key to the instance |
| <a name="output_ssm_port_forward"></a> [ssm\_port\_forward](#output\_ssm\_port\_forward) | Command to start ssm port forwarding session |
| <a name="output_ssm_session"></a> [ssm\_session](#output\_ssm\_session) | Command to start ssm session |
| <a name="output_system_logs_cwl_id"></a> [system\_logs\_cwl\_id](#output\_system\_logs\_cwl\_id) | The IDs of the cloudwatch logs for VM system logs |
| <a name="output_vpc_cidr_blocks"></a> [vpc\_cidr\_blocks](#output\_vpc\_cidr\_blocks) | The CIDR block of the VPC |
| <a name="output_vpc_flow_logs_cwl_id"></a> [vpc\_flow\_logs\_cwl\_id](#output\_vpc\_flow\_logs\_cwl\_id) | The ID of the cloudwatch logs for VPC flow logs |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

## *Author*

* [**Mohamed BASRI**](https://github.com/mbasri)

## *License*

This is free and unencumbered software released into the public domain - see the [LICENSE](./LICENSE) file for details

<!-- END_TF_DOCS -->