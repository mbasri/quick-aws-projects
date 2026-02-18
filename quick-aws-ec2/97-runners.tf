#---------------------------------------------------------------------------------------------------
# User data file ('ascii' format)
#---------------------------------------------------------------------------------------------------
resource "local_file" "run-proxy" {
  filename = "${path.module}/run-proxy"
  content = templatefile("${path.module}/scripts.d/runners.d/run-proxy.sh.tpl", {
    profile                    = "lab"
    region                     = local.region
    instance_id                = module.ec2.instance_id
    instance_availability_zone = module.ec2.instance_availability_zone
  })
}
