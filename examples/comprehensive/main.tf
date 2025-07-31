# ==============================================================================
# COMPREHENSIVE EC2 EXAMPLE - MAXIMUM CUSTOMIZABILITY DEMONSTRATION
# ==============================================================================
# This example demonstrates the extensive customization capabilities of the
# enhanced EC2 module, showcasing security best practices and advanced features

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

# Data sources for networking and AMI selection
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

# KMS key for encryption
resource "aws_kms_key" "ec2" {
  description             = "KMS key for EC2 instance encryption"
  deletion_window_in_days = 7
  
  tags = {
    Name        = "${var.project_name}-ec2-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "ec2" {
  name          = "alias/${var.project_name}-ec2"
  target_key_id = aws_kms_key.ec2.key_id
}

# IAM role for EC2 instance
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

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

  tags = {
    Name        = "${var.project_name}-ec2-role"
    Environment = var.environment
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# Attach CloudWatch agent policy for monitoring
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Comprehensive EC2 instance with maximum customization
module "ec2_comprehensive" {
  source = "../../"

  # ==============================================================================
  # CORE CONFIGURATION
  # ==============================================================================
  instance_type    = var.instance_type
  operating_system = var.operating_system
  key_name        = var.key_name

  # ==============================================================================
  # NETWORK CONFIGURATION
  # ==============================================================================
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [data.aws_security_group.default.id]
  associate_public_ip_address = true
  source_dest_check          = true
  
  # Private IP configuration
  private_ip            = var.private_ip
  secondary_private_ips = var.secondary_private_ips
  
  # IPv6 configuration
  ipv6_address_count = var.ipv6_address_count
  ipv6_addresses     = var.ipv6_addresses

  # ==============================================================================
  # SECURITY CONFIGURATION
  # ==============================================================================
  # Enhanced security with IMDSv2 enforcement
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                = "required"  # IMDSv2 only
    http_put_response_hop_limit = 1          # Secure hop limit
    http_protocol_ipv6         = "disabled"
    instance_metadata_tags     = "enabled"   # Allow tag access
  }
  
  # API protection
  disable_api_termination = var.disable_api_termination
  disable_api_stop       = var.disable_api_stop
  
  # IAM instance profile for secure access
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  # ==============================================================================
  # PERFORMANCE AND OPTIMIZATION
  # ==============================================================================
  # Enhanced monitoring for detailed metrics
  monitoring    = true
  ebs_optimized = true
  
  # CPU configuration for performance tuning
  cpu_options = var.cpu_options != null ? var.cpu_options : {
    core_count       = null  # Use instance default
    threads_per_core = null  # Use instance default
    amd_sev_snp     = null   # AMD-specific security
  }
  
  # Credit specification for burstable instances
  credit_specification = var.credit_specification != null ? var.credit_specification : {
    cpu_credits = "standard"  # or "unlimited" for higher performance
  }

  # ==============================================================================
  # ADVANCED PLACEMENT AND TENANCY
  # ==============================================================================
  availability_zone          = var.availability_zone
  placement_group           = var.placement_group
  placement_partition_number = var.placement_partition_number
  tenancy                   = var.tenancy
  host_id                   = var.host_id
  host_resource_group_arn   = var.host_resource_group_arn

  # ==============================================================================
  # STORAGE CONFIGURATION
  # ==============================================================================
  # Encrypted root volume with custom configuration
  root_block_device = {
    volume_type           = "gp3"
    volume_size          = var.root_volume_size
    iops                 = var.root_volume_iops
    throughput           = var.root_volume_throughput
    encrypted            = true
    kms_key_id          = aws_kms_key.ec2.arn
    delete_on_termination = true
    tags = {
      Name        = "${var.project_name}-root-volume"
      Environment = var.environment
      VolumeType  = "root"
    }
  }
  
  # Additional EBS volumes for data storage
  ebs_block_device = var.additional_volumes

  # ==============================================================================
  # ADVANCED FEATURES
  # ==============================================================================
  # Hibernation support (if supported by instance type)
  hibernation = var.hibernation
  
  # Nitro Enclaves for confidential computing
  enclave_options = var.enclave_options != null ? var.enclave_options : {
    enabled = false
  }
  
  # Maintenance options
  maintenance_options = {
    auto_recovery = "default"
  }
  
  # Private DNS configuration
  private_dns_name_options = {
    enable_resource_name_dns_a_record    = var.enable_resource_name_dns
    enable_resource_name_dns_aaaa_record = var.enable_resource_name_dns_ipv6
    hostname_type                        = var.hostname_type
  }

  # ==============================================================================
  # INITIALIZATION AND USER DATA
  # ==============================================================================
  user_data                   = var.user_data
  user_data_base64           = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change
  
  # Windows-specific configuration
  get_password_data = var.get_password_data

  # ==============================================================================
  # INSTANCE BEHAVIOR
  # ==============================================================================
  instance_initiated_shutdown_behavior = var.shutdown_behavior

  # ==============================================================================
  # ENCRYPTION AND COMPLIANCE
  # ==============================================================================
  enable_encryption = true
  kms_key_id       = aws_kms_key.ec2.arn

  # ==============================================================================
  # TAGGING STRATEGY
  # ==============================================================================
  tags = merge(
    {
      Name         = "${var.project_name}-comprehensive-instance"
      Environment  = var.environment
      Project      = var.project_name
      ManagedBy    = "Terraform"
      Purpose      = "Comprehensive EC2 demonstration"
      Security     = "Enhanced"
      Monitoring   = "Enabled"
      Encryption   = "Enabled"
      Compliance   = "SOC2-Ready"
    },
    var.additional_tags
  )
  
  # Volume-specific tags
  root_block_device_tags = {
    VolumeType = "root"
    Encrypted  = "true"
  }
  
  ebs_block_device_tags = {
    VolumeType = "additional"
    Encrypted  = "true"
  }
}
