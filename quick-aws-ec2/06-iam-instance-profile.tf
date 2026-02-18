#---------------------------------------------------------------------------------------------------
# IAM Instance Profile
#---------------------------------------------------------------------------------------------------
module "iam-instance-profile" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-iam-instance-profile?ref=v1.3.1"

  iam_instance_profile_name = local.iam_instance_profile_name
  description               = local.description

  tags = local.tags
}