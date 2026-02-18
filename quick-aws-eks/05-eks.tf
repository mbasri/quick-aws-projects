#---------------------------------------------------------------------------------------------------
# Create EKS
#---------------------------------------------------------------------------------------------------
module "eks" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-eks?ref=v1.1.2"

  cluster_name    = local.eks_name
  cluster_version = "1.35"

  kms_arn = module.kms.key_arn

  deletion_protection = false

  subnet_ids              = module.vpc.private_subnet_ids
  endpoint_private_access = true
  endpoint_public_access  = true

  public_access_cidrs = [
    "${chomp(data.http.myip.response_body)}/32"
  ]

  eks_admin_principal_arn = [
    data.aws_caller_identity.current.arn
  ]

  enable_autoscaler_pod_identity = true
  enable_alb_pod_identity        = true

  tags = local.tags
}
