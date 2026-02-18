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
# VPC
#---------------------------------------------------------------------------------------------------
output "region" {
  description = "The Name of the region"
  value       = module.vpc.region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_blocks" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_blocks
}

output "nat_gateway_public_ips" {
  description = "Private IP of NAT Gateway"
  value       = module.vpc.nat_gateway_public_ips
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_cidr" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnet_cidr
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "private_subnet_cidr" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnet_cidr
}

output "secure_subnet_ids" {
  description = "List of IDs of secure subnets"
  value       = module.vpc.secure_subnet_ids
}

output "secure_subnet_cidr" {
  description = "List of cidr_blocks of secure subnets"
  value       = module.vpc.secure_subnet_cidr
}

output "default_security_group_id" {
  description = "The ID of the VPC default security group"
  value       = module.vpc.default_security_group_id
}

output "system_logs_cwl_id" {
  description = "The IDs of the cloudwatch logs for VM system logs"
  value       = module.vpc.system_logs_cwl_id
}

output "spot_logs_cwl_id" {
  description = "The IDs of the cloudwatch logs for Spot logging"
  value       = module.vpc.spot_logs_cwl_id
}

output "vpc_flow_logs_cwl_id" {
  description = "The ID of the cloudwatch logs for VPC flow logs"
  value       = module.vpc.vpc_flow_logs_cwl_id
}

#---------------------------------------------------------------------------------------------------
# Security Group
#---------------------------------------------------------------------------------------------------
output "security_group_arn" {
  description = "The ARN of the security group"
  value       = module.security-group.security_group_arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security-group.security_group_id
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.security-group.security_group_vpc_id
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = module.security-group.security_group_owner_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.security-group.security_group_name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = module.security-group.security_group_description
}

#---------------------------------------------------------------------------------------------------
# IAM Instance Profile
#---------------------------------------------------------------------------------------------------
output "iam_instance_profile_arn" {
  description = "The ARN of the IAM Instance Profile"
  value       = module.iam-instance-profile.iam_instance_profile_arn
}

output "iam_instance_profile_id" {
  description = "The ID of the IAM Instance Profile"
  value       = module.iam-instance-profile.iam_instance_profile_id
}

output "iam_instance_profile_name" {
  description = "The Name of the IAM Instance Profile"
  value       = module.iam-instance-profile.iam_instance_profile_name
}

#---------------------------------------------------------------------------------------------------
# EC2
#---------------------------------------------------------------------------------------------------
output "instance_id" {
  description = "The Instance ID"
  value       = module.ec2.instance_id
}

output "instance_arn" {
  description = "The Instance ARN"
  value       = module.ec2.instance_arn
}

output "instance_availability_zone" {
  description = "The availability zone of the created instance"
  value       = module.ec2.instance_availability_zone
}

output "instance_key_name" {
  description = "The Key used by the Instance"
  value       = module.ec2.instance_key_name
}

output "instance_primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = module.ec2.instance_primary_network_interface_id
}

output "instance_private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2.instance_private_dns
}

output "instance_private_ip" {
  description = "The private IP address assigned to the instance"
  value       = module.ec2.instance_private_ip
}

output "instance_vpc_security_group_ids" {
  description = "List of security group used by the instance"
  value       = module.ec2.instance_vpc_security_group_ids
}

output "instance_subnet_id" {
  description = "Subnet used by the instance"
  value       = module.ec2.instance_subnet_id
}

output "instance_instance_state" {
  description = "The state of the instance"
  value       = module.ec2.instance_instance_state
}

output "instance_root_block_device_volume_ids" {
  description = "Root EBS IDs"
  value       = module.ec2.instance_root_block_device_volume_ids
}

output "instance_ebs_block_device_volume_ids" {
  description = "Block devices IDs"
  value       = module.ec2.instance_ebs_block_device_volume_ids
}

output "instance_lifecycle" {
  description = "Indicates whether this is a Spot Instance or a Scheduled Instance"
  value       = module.ec2.instance_lifecycle
}

output "instance_spot_request_id" {
  description = "If the request is a Spot Instance request, the ID of the request"
  value       = module.ec2.instance_spot_request_id
}

#---------------------------------------------------------------------------------------------------
# Others
#---------------------------------------------------------------------------------------------------
output "ssm_session" {
  description = "Command to start ssm session"
  value       = "aws --profile lab --region ${local.region} ssm start-session --target ${module.ec2.instance_id}"
}

output "ssm_port_forward" {
  description = "Command to start ssm port forwarding session"
  value       = "aws --profile lab --region ${local.region} ssm start-session --target ${module.ec2.instance_id} --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"22\"],\"localPortNumber\":[\"2222\"]}' > /dev/null 2>&1 &"
}

output "ssm_copy_ssh_key" {
  description = "Command to copy ssh key to the instance"
  value       = "aws --profile lab --region ${local.region} ec2-instance-connect send-ssh-public-key --instance-id ${module.ec2.instance_id} --availability-zone ${module.ec2.instance_availability_zone} --instance-os-user ec2-user --ssh-public-key file://~/.ssh/.pub"
}

output "ssh_start_socks_v5_proxy" {
  description = "Command to start socks v5 proxy"
  value       = "ssh -fND 127.0.0.1:3000 -p2222 ec2-user@127.0.0.1 -i ~/.ssh/"
}