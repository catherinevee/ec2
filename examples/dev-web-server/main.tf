# Development Web Server Example
module "dev_web_server" {
  source = "../../"

  # Instance Configuration
  instance_type = "t3.small"
  environment   = "dev"

  # Networking
  subnet_id                   = "subnet-12345678"  # Replace with your subnet ID
  vpc_security_group_ids     = ["sg-12345678"]    # Replace with your security group ID
  associate_public_ip_address = true

  # Operating System - Using Ubuntu 22.04
  operating_system = "ubuntu-22.04"

  # Storage Configuration
  root_block_device = {
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }

  # Tags
  mandatory_tags = {
    Environment = "dev"
    Owner       = "web-team"
    CostCenter  = "web-dev-123"
    Project     = "website"
  }

  tags = {
    Name        = "dev-web-server"
    Application = "nginx"
    Role        = "web"
  }

  # Basic Monitoring
  monitoring_config = {
    detailed_monitoring = true
    cpu_threshold      = 70
    memory_threshold   = 70
    disk_threshold     = 80
  }

  # Instance Settings
  instance_config = {
    monitoring    = true
    ebs_optimized = true
    backup        = true
    patch_group   = "dev-weekly"
  }

  # User Data Script for installing web server
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    EOF
  )
}

# Outputs
output "web_server_ip" {
  description = "Public IP of the web server"
  value       = module.dev_web_server.instance_metrics.public_ip
}

output "web_server_dns" {
  description = "Public DNS of the web server"
  value       = module.dev_web_server.network_configuration.public_dns
}

output "web_server_metrics" {
  description = "Web server monitoring metrics"
  value       = module.dev_web_server.instance_metrics
}
