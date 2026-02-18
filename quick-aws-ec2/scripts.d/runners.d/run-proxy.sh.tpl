#!/usr/bin/env bash
set -e

######################################
# run-proxy
# Description: Script to start the SOCKS5 proxy server
# Usage: ./run-proxy
# Author: mbasri <mbasri.dev@outlook.com>
# Version: 1.0
######################################

GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

function display_info {
  printf "$${BLUE}%-10s$${NC} %b\n" "[INFO]" "$${1}"
}

function display_debug {
  printf "$${GREEN}%-10s$${NC} %b\n" "[DEBUG]" "$${1}"
}

# Retrieve the SSH key path
display_info "Retrieving the SSH key path"
SSH_KEY_PATH=`find ~/.ssh ! \( -name "known_hosts*" -o -name "config" -o -name "*.pub" \) -type f`
display_debug "SSH_KEY_PATH: $${SSH_KEY_PATH}"

# Start AWS SSM Session Port Forwarding to the EC2 
display_info "Starting AWS SSM Session Port Forwarding to the EC2 instance"
aws --profile ${profile} --region ${region} ssm start-session --target ${instance_id} --document-name AWS-StartPortForwardingSession --parameters "{\"portNumber\":[\"22\"],\"localPortNumber\":[\"2222\"]}" > /dev/null 2>&1 &
SSM_PID=$!
display_debug "SSM_PID: $${SSM_PID}"

# Copy temporary SSH public key to the EC2 instance
display_info "Copying temporary SSH public key to the EC2 instance"
aws --profile ${profile} --region ${region} ec2-instance-connect send-ssh-public-key --instance-id ${instance_id} --availability-zone ${instance_availability_zone} --instance-os-user ec2-user --ssh-public-key file://$${SSH_KEY_PATH}.pub > /dev/null 2>&1

# Start the SOCKS5 proxy server
display_info "Starting the SOCKS5 proxy server"
ssh -fND 127.0.0.1:3000 -p2222 ec2-user@127.0.0.1 -i $${SSH_KEY_PATH} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes -o ConnectTimeout=10 > /dev/null 2>&1
PROXY_PID=$!
display_debug "PROXY_PID: $${PROXY_PID}"

# Command to stop the SOCKS5 proxy server and AWS SSM Session Port Forwarding
display_info "Command to stop the SOCKS5 proxy server and AWS SSM Session Port Forwarding"
display_info "kill -9 $${PROXY_PID} $${SSM_PID}"
