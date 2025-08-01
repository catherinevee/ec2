# Basic Web Server Example
# This example creates an EC2 instance configured as a simple web server

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources for networking
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group for web server
resource "aws_security_group" "web_server" {
  name_prefix = "web-server-"
  description = "Security group for web server"
  vpc_id      = data.aws_vpc.default.id

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access (optional)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }
}

# User data script to install and start Apache
locals {
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Create a simple index page
    cat > /var/www/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to My Web Server</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
            .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            h1 { color: #333; }
            .info { background-color: #e7f3ff; padding: 15px; border-radius: 4px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎉 Web Server is Running!</h1>
            <p>This is a basic web server created with Terraform and the EC2 module.</p>
            <div class="info">
                <strong>Server Information:</strong><br>
                Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)<br>
                Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)<br>
                Instance Type: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)
            </div>
            <p>You can customize this page by modifying the user data script in your Terraform configuration.</p>
        </div>
    </body>
    </html>
HTML
    EOF
  )
}

# Web server EC2 instance
module "web_server" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # SSH Configuration (optional)
  key_name = var.key_name

  # Networking
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [aws_security_group.web_server.id]
  associate_public_ip_address = true

  # Web server configuration
  user_data_base64 = local.user_data

  # Monitoring
  monitoring = true

  # Tags
  tags = {
    Name        = "Basic-Web-Server"
    Environment = "example"
    Purpose     = "Web server demonstration"
    Service     = "HTTP"
  }
}
