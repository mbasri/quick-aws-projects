#---------------------------------------------------------------------------------------------------
# Retreive Cert
#---------------------------------------------------------------------------------------------------
data "aws_acm_certificate" "server" {
  domain   = "server.net"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "client" {
  domain   = "client.net"
  statuses = ["ISSUED"]
}
