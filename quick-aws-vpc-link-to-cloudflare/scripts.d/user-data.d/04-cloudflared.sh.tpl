#!/usr/bin/env bash
set -xe

#---------------------------------------------------------------------------------------------------
# Install cloudflared binary (arm64) — download to /tmp then move to PATH
#---------------------------------------------------------------------------------------------------
curl -Lo /tmp/cloudflared \
  "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
chmod +x /tmp/cloudflared
mv /tmp/cloudflared /usr/local/bin/cloudflared

#---------------------------------------------------------------------------------------------------
# Fetch the tunnel token from SSM Parameter Store (SecureString — KMS-decrypted at runtime)
# The token is never stored in user data or instance metadata
#---------------------------------------------------------------------------------------------------
TUNNEL_TOKEN=$(aws ssm get-parameter \
  --name "${ssm_cloudflare_tunnel_token_name}" \
  --with-decryption \
  --region "${region}" \
  --query 'Parameter.Value' \
  --output text)

#---------------------------------------------------------------------------------------------------
# Register cloudflared as a systemd service and start it
# cloudflared service install writes /etc/systemd/system/cloudflared.service
#---------------------------------------------------------------------------------------------------
cloudflared service install "$${TUNNEL_TOKEN}"
systemctl enable cloudflared
systemctl start cloudflared
