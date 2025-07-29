#!/bin/bash

# Update system
yum update -y

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent

# Install SSM agent (usually pre-installed on Amazon Linux 2)
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Create application directory
mkdir -p /opt/${app_name}
chown ec2-user:ec2-user /opt/${app_name}

# Set environment variables
echo "export ENVIRONMENT=${environment}" >> /etc/environment
echo "export APP_NAME=${app_name}" >> /etc/environment

# Format and mount additional EBS volume
if [ -b /dev/xvdf ]; then
    # Check if the device is already formatted
    if ! blkid /dev/xvdf; then
        mkfs -t xfs /dev/xvdf
    fi
    
    # Create mount point
    mkdir -p /data
    
    # Add to fstab for persistent mounting
    echo '/dev/xvdf /data xfs defaults,nofail 0 2' >> /etc/fstab
    
    # Mount the volume
    mount -a
    
    # Set permissions
    chown ec2-user:ec2-user /data
fi

# Install Docker (optional)
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

# Install basic monitoring tools
yum install -y htop iotop

# Create a simple health check script
cat > /opt/health-check.sh << 'EOF'
#!/bin/bash
# Simple health check script
echo "$(date): System health check" >> /var/log/health-check.log
df -h >> /var/log/health-check.log
free -m >> /var/log/health-check.log
echo "---" >> /var/log/health-check.log
EOF

chmod +x /opt/health-check.sh

# Add health check to crontab
echo "*/5 * * * * /opt/health-check.sh" | crontab -

# Signal that user data execution is complete
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource AutoScalingGroup --region ${AWS::Region} || true

echo "User data script completed successfully" >> /var/log/user-data.log
