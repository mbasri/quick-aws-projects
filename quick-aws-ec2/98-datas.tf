#---------------------------------------------------------------------------------------------------
# Get the latest Amazon Linux 2023 AMI
#---------------------------------------------------------------------------------------------------
data "aws_ami" "latest" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

#---------------------------------------------------------------------------------------------------
# User data file ('ascii' format)
#---------------------------------------------------------------------------------------------------
data "cloudinit_config" "main" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts.d/user-data.d/01-init.sh.tpl", {
      region             = local.region
      ssm_parameter_name = local.ssm_parameter_name
    })
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts.d/user-data.d/02-tagger.sh.tpl", {
      region = local.region
    })
  }
}
