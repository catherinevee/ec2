# Private EC2 Instance Example
# This example creates an EC2 instance in a private subnet without public IP

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

# Create a private security group (no inbound internet access)
resource "aws_security_group" "private_instance" {
  name_prefix = "private-instance-"
  description = "Security group for private EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound traffic from within the VPC only
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  # Allow all outbound traffic (for updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Instance Security Group"
  }
}

# Optional: Create VPC Endpoint for S3 (for private connectivity)
resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc_endpoints ? 1 : 0
  
  vpc_id       = data.aws_vpc.default.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  
  tags = {
    Name = "S3 VPC Endpoint"
  }
}

# Optional: Create VPC Endpoint for EC2 (for private connectivity)
resource "aws_vpc_endpoint" "ec2" {
  count = var.create_vpc_endpoints ? 1 : 0
  
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.aws_subnets.default.ids
  security_group_ids  = [aws_security_group.private_instance.id]
  
  tags = {
    Name = "EC2 VPC Endpoint"
  }
}

# Private EC2 instance
module "private_ec2" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # SSH Configuration
  key_name = var.key_name

  # Networking - Private configuration
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [aws_security_group.private_instance.id]
  associate_public_ip_address = false  # No public IP

  # Instance configuration
  monitoring = true

  # User data for basic setup
  user_data_base64 = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y htop curl wget
    
    # Create a simple status file
    echo "Private instance initialized at $(date)" > /home/ec2-user/status.txt
    echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /home/ec2-user/status.txt
    echo "Private IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)" >> /home/ec2-user/status.txt
    
    chown ec2-user:ec2-user /home/ec2-user/status.txt
  EOF
  )

  # Tags
  tags = {
    Name        = "Private-EC2-Instance"
    Environment = "example"
    Purpose     = "Private subnet demonstration"
    NetworkType = "private"
  }
}
