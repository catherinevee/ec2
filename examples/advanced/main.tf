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

# Data sources
data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Type = "private"
  }
}

data "aws_security_groups" "web" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Name = "*web*"
  }
}

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

# IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "${var.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = var.tags
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# User data script
locals {
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    environment = var.environment
    app_name    = var.app_name
  }))
}

# Advanced EC2 instance using the module
module "web_server" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # Operating System Configuration
  operating_system = var.operating_system

  # Networking
  subnet_id                   = data.aws_subnets.private.ids[0]
  vpc_security_group_ids     = data.aws_security_groups.web.ids
  associate_public_ip_address = false

  # Instance Configuration
  key_name                            = var.key_name
  monitoring                          = true
  ebs_optimized                      = true
  disable_api_termination            = var.enable_termination_protection
  instance_initiated_shutdown_behavior = "stop"
  iam_instance_profile               = aws_iam_instance_profile.ec2_profile.name

  # User Data
  user_data_base64            = local.user_data
  user_data_replace_on_change = true

  # Storage Configuration
  root_block_device = {
    volume_type           = "gp3"
    volume_size          = var.root_volume_size
    encrypted            = true
    kms_key_id          = data.aws_kms_key.ebs.arn
    delete_on_termination = true
    throughput           = 125
    iops                 = 3000
  }

  ebs_block_device = [
    {
      device_name           = "/dev/sdf"
      volume_type          = "gp3"
      volume_size          = var.data_volume_size
      encrypted            = true
      kms_key_id          = data.aws_kms_key.ebs.arn
      delete_on_termination = true
      throughput           = 125
      iops                 = 3000
    }
  ]

  # Security Configuration
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # CPU Configuration for burstable instances
  cpu_credits = var.instance_type == "t3.micro" || var.instance_type == "t3.small" ? "unlimited" : null

  # Maintenance options
  maintenance_options = {
    auto_recovery = "default"
  }

  # Private DNS configuration
  private_dns_name_options = {
    hostname_type                        = "resource-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
  }

  # Tags
  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-web-server"
    Environment = var.environment
    Application = var.app_name
    Backup      = "daily"
    Monitoring  = "enabled"
  })

  instance_tags = {
    InstanceType = "web-server"
    Role         = "frontend"
  }

  volume_tags = {
    VolumeType = "system"
    Encrypted  = "true"
  }
}
