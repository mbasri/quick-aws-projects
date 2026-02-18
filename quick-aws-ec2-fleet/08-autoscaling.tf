#---------------------------------------------------------------------------------------------------
# Auto Scaling Group
#---------------------------------------------------------------------------------------------------
module "autoscaling" {
  source = "git::https://github.com/mbasri-terraform-aws-modules/terraform-aws-autoscaling?ref=v1.1.1"

  autoscaling_name = local.autoscaling_name

  image_id = data.aws_ami.latest.id

  instance_types = [
    "t4g.micro",
    "t4g.small"
  ]

  min_size = 1
  max_size = 2

  subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [
    module.security-group-ec2.security_group_id
  ]

  user_data = data.cloudinit_config.main.rendered

  iam_instance_profile = module.iam-instance-profile.iam_instance_profile_id

  root_block_device = {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = module.kms.key_arn
    iops                  = 100
    throughput            = 125
    volume_size           = 32
    volume_type           = "gp3"
  }

  target_group_arns = [
    aws_lb_target_group.this.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  tags = local.tags
}