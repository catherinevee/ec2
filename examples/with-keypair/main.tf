# EC2 Instance with SSH Key Pair Example
# This example creates an EC2 instance with SSH access enabled

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

# Create a security group that allows SSH access
resource "aws_security_group" "ssh_access" {
  name_prefix = "ec2-ssh-access-"
  description = "Security group for EC2 instance with SSH access"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Note: Restrict this in production
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 SSH Access"
  }
}

# EC2 instance with SSH key pair
module "ec2_with_keypair" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # SSH Configuration
  key_name = var.key_name

  # Networking
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true

  # Basic configuration
  monitoring = true

  # Tags
  tags = {
    Name        = "EC2-with-SSH"
    Environment = "example"
    Purpose     = "SSH-accessible instance"
  }
}
