#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
# Instance Info Web Server
#---------------------------------------------------------------------------------------------------
dnf install -y nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-type)
LIFECYCLE=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/instance-life-cycle)
AMI_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/ami-id)
IAM_ROLE=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/iam/info | jq -r '.InstanceProfileArn // empty' | awk -F/ '{print $NF}')

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/local-ipv4)
REGION=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/placement/region)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/placement/availability-zone)
MAC=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" http://169.254.169.254/latest/meta-data/mac)
VPC_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" "http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}/vpc-id")
SUBNET_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" "http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}/subnet-id")

KERNEL=$(uname -r)
CPU=$(nproc)
MEM=$(free -h | awk '/^Mem:/{print $2}')
DISK=$(df -h / | awk 'NR==2{print $2}')

[ "$LIFECYCLE" = "spot" ] && BADGE_CLASS="spot" || BADGE_CLASS="on-demand"
GENERATED_AT=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

cat > /usr/share/nginx/html/index.html << HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>$INSTANCE_ID</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Courier New', monospace; background: #0a0a0a; color: #c8c8c8; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 24px; }
    .card { background: #141414; border: 1px solid #252525; border-radius: 6px; padding: 28px 32px; width: 100%; max-width: 760px; }
    header { display: flex; align-items: baseline; gap: 16px; margin-bottom: 28px; padding-bottom: 20px; border-bottom: 1px solid #222; }
    header h1 { color: #ff9900; font-size: 15px; letter-spacing: 2px; text-transform: uppercase; }
    header span { color: #555; font-size: 13px; }
    .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 28px; }
    section h2 { color: #444; font-size: 10px; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 14px; }
    .row { margin-bottom: 12px; }
    .label { color: #555; font-size: 11px; margin-bottom: 3px; }
    .value { color: #e8e8e8; font-size: 13px; word-break: break-all; }
    .badge { font-size: 11px; padding: 2px 7px; border-radius: 3px; }
    .spot { background: #2a1e10; color: #ff9900; }
    .on-demand { background: #1a2a1a; color: #6abf69; }
    footer { margin-top: 24px; padding-top: 16px; border-top: 1px solid #1e1e1e; color: #333; font-size: 11px; }
  </style>
</head>
<body>
  <div class="card">
    <header>
      <h1>EC2 Instance</h1>
      <span>$INSTANCE_ID</span>
    </header>
    <div class="grid">
      <section>
        <h2>Instance</h2>
        <div class="row"><div class="label">Type</div><div class="value">$INSTANCE_TYPE</div></div>
        <div class="row"><div class="label">Lifecycle</div><div class="value"><span class="badge $BADGE_CLASS">$LIFECYCLE</span></div></div>
        <div class="row"><div class="label">AMI</div><div class="value">$AMI_ID</div></div>
        <div class="row"><div class="label">IAM Role</div><div class="value">$IAM_ROLE</div></div>
      </section>
      <section>
        <h2>Network</h2>
        <div class="row"><div class="label">Private IP</div><div class="value">$PRIVATE_IP</div></div>
        <div class="row"><div class="label">Region</div><div class="value">$REGION</div></div>
        <div class="row"><div class="label">Availability Zone</div><div class="value">$AZ</div></div>
        <div class="row"><div class="label">VPC</div><div class="value">$VPC_ID</div></div>
        <div class="row"><div class="label">Subnet</div><div class="value">$SUBNET_ID</div></div>
      </section>
      <section>
        <h2>System</h2>
        <div class="row"><div class="label">Kernel</div><div class="value">$KERNEL</div></div>
        <div class="row"><div class="label">vCPU</div><div class="value">$CPU</div></div>
        <div class="row"><div class="label">Memory</div><div class="value">$MEM</div></div>
        <div class="row"><div class="label">Disk (/)</div><div class="value">$DISK</div></div>
      </section>
    </div>
    <footer>Generated at $GENERATED_AT</footer>
  </div>
</body>
</html>
HTML

systemctl enable nginx
systemctl start nginx
