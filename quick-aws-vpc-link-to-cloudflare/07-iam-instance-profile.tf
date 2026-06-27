#---------------------------------------------------------------------------------------------------
# IAM Policy: read Cloudflare tunnel token from SSM (least privilege — scoped to exact param + key)
#---------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "cloudflare-tunnel-token" {
  name        = local.cloudflare_tunnel_iam_policy_name
  description = "Allow EC2 to read Cloudflare tunnel token from SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = aws_ssm_parameter.cloudflare-tunnel-token.arn
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = module.kms.key_arn
      }
    ]
  })

  tags = merge(local.tags, tomap({ "Name" = local.cloudflare_tunnel_iam_policy_name }))
}

#---------------------------------------------------------------------------------------------------
# IAM Instance Profile
#---------------------------------------------------------------------------------------------------
module "iam-instance-profile" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-iam-instance-profile?ref=v1"

  iam_instance_profile_name = local.iam_instance_profile_name
  description               = local.description

  policies_arn = [aws_iam_policy.cloudflare-tunnel-token.arn]

  tags = local.tags
}
