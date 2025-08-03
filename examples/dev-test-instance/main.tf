# Development Testing Environment Example
module "dev_test_instance" {
  source = "../../"

  # Instance Configuration
  instance_type = "t3.medium"
  environment   = "dev"

  # Networking
  subnet_id                   = "subnet-12345678"  # Replace with your subnet ID
  vpc_security_group_ids     = ["sg-12345678"]    # Replace with your security group ID
  associate_public_ip_address = true               # Allow public access for testing

  # Operating System - Latest Amazon Linux 2023
  operating_system = "amazon-linux-2023"

  # Storage Configuration - Basic for testing
  root_block_device = {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
  }

  # Tags
  mandatory_tags = {
    Environment = "dev"
    Owner       = "test-team"
    CostCenter  = "test-789"
    Project     = "testing"
  }

  tags = {
    Name        = "dev-test-instance"
    Application = "testing"
    Role        = "test"
    AutoStop    = "true"  # Indicate this instance can be automatically stopped
  }

  # Basic Monitoring for Testing
  monitoring_config = {
    detailed_monitoring = false  # Basic monitoring is sufficient for testing
    cpu_threshold      = 90     # Higher threshold for testing
    memory_threshold   = 90
    disk_threshold     = 90
  }

  # Development Instance Settings
  instance_config = {
    monitoring    = false
    ebs_optimized = false
    backup        = false       # No backup needed for test instances
    patch_group   = "dev-test"
  }

  # User Data for installing testing tools
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker git
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    EOF
  )
}

# Outputs
output "test_instance_ip" {
  description = "Public IP of the test instance"
  value       = module.dev_test_instance.instance_metrics.public_ip
}

output "test_instance_dns" {
  description = "Public DNS of the test instance"
  value       = module.dev_test_instance.network_configuration.public_dns
}

output "test_instance_id" {
  description = "Instance ID"
  value       = module.dev_test_instance.instance_metrics.instance_id
}
