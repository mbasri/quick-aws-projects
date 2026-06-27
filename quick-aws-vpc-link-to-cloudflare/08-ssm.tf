#---------------------------------------------------------------------------------------------------
# Save cloudwatch Agent configuration
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
#
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html
# ex: sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
#
# Used by user-data
#---------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "cloudwatch-agent-config" {
  name        = local.ssm_parameter_name
  description = local.description
  type        = "String"
  value = templatefile("${path.module}/ssm.d/01-cloudwatch-agent.json", {
    vpc_id = module.vpc.vpc_id
  })
  tags = merge(local.tags, tomap({ "Name" = local.ssm_parameter_name }))
  tier = "Advanced"
}

#---------------------------------------------------------------------------------------------------
# Cloudflare tunnel token — stored as SecureString encrypted with the project KMS key
# The EC2 instance retrieves this at boot via: aws ssm get-parameter --with-decryption
# The token itself never appears in user data or Terraform plan output
#---------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "cloudflare-tunnel-token" {
  name        = local.cloudflare_tunnel_ssm_param_name
  description = "Cloudflare tunnel connector token for ${local.description}"
  type        = "SecureString"
  key_id      = module.kms.key_arn
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.main.token
  tags        = merge(local.tags, tomap({ "Name" = local.cloudflare_tunnel_ssm_param_name }))
  tier        = "Standard"
}
