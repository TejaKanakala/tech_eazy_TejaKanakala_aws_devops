#!/bin/bash

# === DevOps Assignment 1: Automate EC2 Deployment ===
set -e

# Load Stage and corresponding config
STAGE=${1:-"dev"}
CONFIG_FILE="${STAGE}_config.env"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file $CONFIG_FILE not found!"
  exit 1
fi

# Load environment variables from config
source "$CONFIG_FILE"

# Path to your private key file (Windows path for Git Bash)
KEY_PATH="/c/Users/Admin/Downloads/techeazy-key.pem"


# Launch EC2 instance
echo "Launching EC2 instance with profile $IAM_INSTANCE_PROFILE..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP" \
  --iam-instance-profile Name="$IAM_INSTANCE_PROFILE" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Launched EC2 instance: $INSTANCE_ID"

# Wait for EC2 to be running
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get public DNS
INSTANCE_DNS=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicDnsName" \
  --output text)

echo "Instance DNS: $INSTANCE_DNS"

# Wait for instance boot
echo "Waiting for instance to be ready for SSH..."
sleep 60

# Connect and deploy
ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" ec2-user@"$INSTANCE_DNS" << EOF
  sudo yum update -y
  sudo yum install -y java-19-openjdk git
  git clone https://github.com/techeazy-consulting/techeazy-devops app
  cd app
  chmod +x start.sh || true
  ./start.sh || echo "App start script failed or needs adjustment"
EOF

# Health check
echo "Performing health check on http://$INSTANCE_DNS:80..."
curl http://"$INSTANCE_DNS":80 || echo "⚠️ App might not be reachable yet!"

# Schedule shutdown
echo "Waiting $SHUTDOWN_AFTER seconds before stopping instance to save cost..."
sleep "$SHUTDOWN_AFTER"
aws ec2 stop-instances --instance-ids "$INSTANCE_ID"
echo "✅ EC2 instance stopped."
