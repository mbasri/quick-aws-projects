#---------------------------------------------------------------------------------------------------
# Random 32-byte secret for the Cloudflare tunnel
# Stored securely in the Cloudflare control plane — never exposed in plan/apply output
#---------------------------------------------------------------------------------------------------
resource "random_id" "tunnel_secret" {
  byte_length = 32
}

#---------------------------------------------------------------------------------------------------
# Cloudflare Zero Trust Tunnel (cloudflared)
# https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
#
# tunnel_token is a sensitive computed attribute — Terraform will never print it
# It is stored in SSM Parameter Store (SecureString) via 08-ssm.tf
#---------------------------------------------------------------------------------------------------
resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id    = var.cloudflare_account_id
  name          = local.cloudflare_tunnel_name
  tunnel_secret = random_id.tunnel_secret.b64_std
  config_src    = "cloudflare"
}

#---------------------------------------------------------------------------------------------------
# Fetch the connector token — separate data source in v5 (no tunnel_token attribute on resource)
#---------------------------------------------------------------------------------------------------
data "cloudflare_zero_trust_tunnel_cloudflared_token" "main" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.main.id
}

#---------------------------------------------------------------------------------------------------
# Private network route: traffic to the VPC CIDR is forwarded through the tunnel
# Requires the WARP client split tunnel to include this CIDR (remove 10.0.0.0/8 from exclusions)
#---------------------------------------------------------------------------------------------------
resource "cloudflare_zero_trust_tunnel_cloudflared_route" "vpc" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.main.id
  network    = local.vpc_cidr
  comment    = local.description
}
