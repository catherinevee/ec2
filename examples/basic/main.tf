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

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Basic EC2 instance using the module
module "ec2_instance" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # Optional - Operating System
  operating_system = var.operating_system

  # Optional - Networking
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  # Optional - Configuration
  key_name   = var.key_name
  monitoring = true

  # Optional - Storage
  root_block_device = {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  # Optional - Tags
  tags = {
    Name        = "example-instance"
    Environment = "development"
    Project     = "terraform-aws-ec2-module"
    ManagedBy   = "terraform"
  }

  instance_tags = {
    Type = "web-server"
  }
}
