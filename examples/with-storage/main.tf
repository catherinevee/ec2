# EC2 Instance with Custom Storage Example
# This example demonstrates various EBS storage configurations

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

# EC2 instance with custom storage configuration
module "ec2_with_storage" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # SSH Configuration
  key_name = var.key_name

  # Networking
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  # Root volume configuration
  root_block_device = [{
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = var.root_volume_type == "gp3" ? var.root_volume_iops : null
    throughput            = var.root_volume_type == "gp3" ? var.root_volume_throughput : null
    encrypted             = true
    delete_on_termination = true
    
    tags = {
      Name        = "Root Volume"
      VolumeType  = "root"
      Environment = "example"
    }
  }]

  # Additional EBS volumes
  ebs_block_device = [
    # Data volume
    {
      device_name           = "/dev/sdf"
      volume_type           = var.data_volume_type
      volume_size           = var.data_volume_size
      iops                  = var.data_volume_type == "gp3" ? var.data_volume_iops : null
      throughput            = var.data_volume_type == "gp3" ? var.data_volume_throughput : null
      encrypted             = true
      delete_on_termination = var.delete_volumes_on_termination
      
      tags = {
        Name        = "Data Volume"
        VolumeType  = "data"
        Environment = "example"
        Purpose     = "Application data storage"
      }
    },
    # Log volume (if enabled)
    var.create_log_volume ? {
      device_name           = "/dev/sdg"
      volume_type           = "gp3"
      volume_size           = var.log_volume_size
      iops                  = 3000
      throughput            = 125
      encrypted             = true
      delete_on_termination = var.delete_volumes_on_termination
      
      tags = {
        Name        = "Log Volume"
        VolumeType  = "logs"
        Environment = "example"
        Purpose     = "Application logs"
      }
    } : null
  ]

  # EBS optimization
  ebs_optimized = var.ebs_optimized

  # User data to mount additional volumes
  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
    create_log_volume = var.create_log_volume
    log_volume_size   = var.log_volume_size
  }))

  # Monitoring
  monitoring = true

  # Tags
  tags = {
    Name        = "EC2-with-Custom-Storage"
    Environment = "example"
    Purpose     = "Storage configuration demonstration"
    StorageType = "multi-volume"
  }
}
