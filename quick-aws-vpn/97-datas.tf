#---------------------------------------------------------------------------------------------------
# Retrieve Cert (kept for reference - certificates are now managed in 07-certificates.tf)
#---------------------------------------------------------------------------------------------------
# data "aws_acm_certificate" "server" {
#   domain   = "server.net"
#   statuses = ["ISSUED"]
# }
#
# data "aws_acm_certificate" "client" {
#   domain   = "client.net"
#   statuses = ["ISSUED"]
# }
