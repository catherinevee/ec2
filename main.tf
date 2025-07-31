# AWS EC2 Terraform Module - Enhanced for Maximum Customizability
# This module provides comprehensive EC2 instance configuration with all available parameters
# Default values are chosen for production readiness and security best practices

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Operating system configuration mapping
locals {
  os_config = {
    "amazon-linux-2" = {
      owners      = ["amazon"]
      name_filter = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    "amazon-linux-2023" = {
      owners      = ["amazon"]
      name_filter = ["al2023-ami-*-x86_64"]
    }
    "ubuntu-20.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    "ubuntu-22.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    "ubuntu-24.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
    }
    "rhel-8" = {
      owners      = ["309956199498"] # Red Hat
      name_filter = ["RHEL-8.*_HVM-*-x86_64-*-Hourly2-GP2"]
    }
    "rhel-9" = {
      owners      = ["309956199498"] # Red Hat
      name_filter = ["RHEL-9.*_HVM-*-x86_64-*-Hourly2-GP3"]
    }
    "centos-7" = {
      owners      = ["125523088429"] # CentOS
      name_filter = ["CentOS 7.*x86_64"]
    }
    "windows-2019" = {
      owners      = ["amazon"]
      name_filter = ["Windows_Server-2019-English-Full-Base-*"]
    }
    "windows-2022" = {
      owners      = ["amazon"]
      name_filter = ["Windows_Server-2022-English-Full-Base-*"]
    }
  }

  # Use OS-specific configuration if ami_id is null, otherwise use provided values
  ami_owners      = var.ami_id == null ? local.os_config[var.operating_system].owners : var.ami_owners
  ami_name_filter = var.ami_id == null ? local.os_config[var.operating_system].name_filter : var.ami_name_filter
}

# Data source for AMI
data "aws_ami" "this" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = local.ami_owners

  filter {
    name   = "name"
    values = local.ami_name_filter
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# ==============================================================================
# EC2 INSTANCE RESOURCE - COMPREHENSIVE CONFIGURATION
# ==============================================================================
# This resource creates an EC2 instance with all possible customizable parameters
# Default values are optimized for security, performance, and cost-effectiveness

resource "aws_instance" "this" {
  # CORE INSTANCE CONFIGURATION
  # AMI ID - Uses data source lookup if not specified (default: latest Amazon Linux 2)
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.this[0].id
  
  # Instance type - No default, must be specified by user
  instance_type = var.instance_type
  
  # Key pair for SSH access - Optional, but recommended for access
  key_name = var.key_name
  
  # NETWORK CONFIGURATION
  # VPC security groups - Controls network access (default: none, user must specify)
  vpc_security_group_ids = var.vpc_security_group_ids
  
  # Subnet placement - Optional, uses default subnet if not specified
  subnet_id = var.subnet_id
  
  # Public IP assignment - Default: null (inherits subnet setting)
  # Set to true for public subnets, false for private subnets
  associate_public_ip_address = var.associate_public_ip_address
  
  # Availability zone - Optional, AWS chooses if not specified
  availability_zone = var.availability_zone
  
  # Private IP address - Optional, AWS assigns if not specified
  private_ip = var.private_ip
  
  # Additional private IPs - Default: empty list
  secondary_private_ips = var.secondary_private_ips
  
  # IPv6 configuration - Default: 0 addresses
  ipv6_address_count = var.ipv6_address_count
  ipv6_addresses     = var.ipv6_addresses
  
  # Source/destination check - Default: true (disable for NAT instances)
  source_dest_check = var.source_dest_check
  
  # PLACEMENT AND TENANCY
  # Placement group for cluster networking - Default: none
  placement_group = var.placement_group
  
  # Tenancy type - Default: "default" (shared hardware)
  # Options: "default", "dedicated", "host"
  tenancy = var.tenancy
  
  # Dedicated host ID - Only used with "host" tenancy
  host_id = var.host_id
  
  # Host resource group ARN - For host resource groups
  host_resource_group_arn = var.host_resource_group_arn
  
  # CPU CONFIGURATION
  # CPU core count - Default: null (uses instance type default)
  cpu_core_count = var.cpu_core_count
  
  # Threads per core - Default: null (uses instance type default)
  # Set to 1 to disable hyperthreading
  cpu_threads_per_core = var.cpu_threads_per_core
  
  # PERFORMANCE AND OPTIMIZATION
  # EBS optimization - Default: null (uses instance type default)
  # Recommended: true for most production workloads
  ebs_optimized = var.ebs_optimized
  
  # Enhanced monitoring - Default: false (basic monitoring)
  # Set to true for detailed CloudWatch metrics (additional cost)
  monitoring = var.monitoring
  
  # Hibernation support - Default: false
  # Only supported on specific instance types
  hibernation = var.hibernation
  
  # SECURITY CONFIGURATION
  # API termination protection - Default: false
  # Recommended: true for production instances
  disable_api_termination = var.disable_api_termination
  
  # API stop protection - Default: false
  disable_api_stop = var.disable_api_stop
  
  # Shutdown behavior - Default: "stop"
  # Options: "stop", "terminate"
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  
  # IAM instance profile - Default: none
  # Recommended: create specific role for instance permissions
  iam_instance_profile = var.iam_instance_profile
  
  # USER DATA AND INITIALIZATION
  # User data script - Default: none
  # Use either user_data OR user_data_base64, not both
  user_data = var.user_data
  
  # Base64 encoded user data - Default: none
  user_data_base64 = var.user_data_base64
  
  # Replace instance on user data change - Default: false
  # Set to true to force replacement when user data changes
  user_data_replace_on_change = var.user_data_replace_on_change
  
  # WINDOWS-SPECIFIC CONFIGURATION
  # Get Windows password data - Default: false
  # Only applicable for Windows instances
  get_password_data = var.get_password_data
  
  # ADVANCED PLACEMENT CONFIGURATION
  # Placement partition number - Default: null
  # Used with partition placement groups
  placement_partition_number = var.placement_partition_number
  
  # METADATA SERVICE CONFIGURATION
  # Instance metadata service options - Enhanced security settings
  # Default: IMDSv2 required for security best practices
  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      # HTTP endpoint - Default: "enabled"
      # Options: "enabled", "disabled"
      http_endpoint = lookup(metadata_options.value, "http_endpoint", "enabled")
      
      # HTTP PUT response hop limit - Default: 1 (secure)
      # Range: 1-64, lower values are more secure
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", 1)
      
      # HTTP tokens requirement - Default: "required" (IMDSv2)
      # Options: "optional" (IMDSv1+v2), "required" (IMDSv2 only)
      http_tokens = lookup(metadata_options.value, "http_tokens", "required")
      
      # HTTP protocol IPv6 - Default: "disabled"
      # Options: "enabled", "disabled"
      http_protocol_ipv6 = lookup(metadata_options.value, "http_protocol_ipv6", "disabled")
      
      # Instance metadata tags - Default: "disabled"
      # Options: "enabled", "disabled"
      instance_metadata_tags = lookup(metadata_options.value, "instance_metadata_tags", "disabled")
    }
  }
  
  # BURSTABLE INSTANCE CREDIT CONFIGURATION
  # Credit specification for T2/T3/T4g instances - Default: null
  # Controls CPU credit behavior for burstable instances
  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []
    content {
      # CPU credits - Default: "standard"
      # Options: "standard", "unlimited"
      # "unlimited" allows bursting beyond baseline (additional charges may apply)
      cpu_credits = lookup(credit_specification.value, "cpu_credits", "standard")
    }
  }
  
  # CPU OPTIONS CONFIGURATION
  # Advanced CPU configuration - Default: null (uses instance defaults)
  dynamic "cpu_options" {
    for_each = var.cpu_options != null ? [var.cpu_options] : []
    content {
      # Core count - Default: null (uses instance type default)
      # Note: This replaces the deprecated cpu_core_count parameter
      core_count = lookup(cpu_options.value, "core_count", null)
      
      # Threads per core - Default: null (uses instance type default)
      # Set to 1 to disable hyperthreading for security/licensing
      threads_per_core = lookup(cpu_options.value, "threads_per_core", null)
      
      # AMD SEV-SNP - Default: null
      # Options: "enabled", "disabled" (AMD instances only)
      amd_sev_snp = lookup(cpu_options.value, "amd_sev_snp", null)
    }
  }
  
  # NITRO ENCLAVE CONFIGURATION
  # AWS Nitro Enclaves for confidential computing - Default: null
  dynamic "enclave_options" {
    for_each = var.enclave_options != null ? [var.enclave_options] : []
    content {
      # Enable Nitro Enclaves - Default: false
      # Requires supported instance types (M5, M5a, M5n, etc.)
      enabled = lookup(enclave_options.value, "enabled", false)
    }
  }
  
  # MAINTENANCE OPTIONS
  # Instance maintenance options - Default: null
  dynamic "maintenance_options" {
    for_each = var.maintenance_options != null ? [var.maintenance_options] : []
    content {
      # Auto recovery - Default: "default"
      # Options: "default", "disabled"
      auto_recovery = lookup(maintenance_options.value, "auto_recovery", "default")
    }
  }
  
  # PRIVATE DNS NAME OPTIONS
  # Private DNS name configuration - Default: null
  dynamic "private_dns_name_options" {
    for_each = var.private_dns_name_options != null ? [var.private_dns_name_options] : []
    content {
      # Enable resource name DNS A record - Default: false
      enable_resource_name_dns_a_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_a_record", false)
      
      # Enable resource name DNS AAAA record - Default: false
      enable_resource_name_dns_aaaa_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_aaaa_record", false)
      
      # Hostname type - Default: "ip-name"
      # Options: "ip-name", "resource-name"
      hostname_type = lookup(private_dns_name_options.value, "hostname_type", "ip-name")
    }
  }
  
  # STORAGE CONFIGURATION
  # Root block device
  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? [var.root_block_device] : []
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", true)
      encrypted             = lookup(root_block_device.value, "encrypted", var.enable_encryption)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id           = lookup(root_block_device.value, "kms_key_id", var.kms_key_id)
      tags                 = merge(var.tags, var.root_block_device_tags, lookup(root_block_device.value, "tags", {}))
      throughput           = lookup(root_block_device.value, "throughput", null)
      volume_size          = lookup(root_block_device.value, "volume_size", 8)
      volume_type          = lookup(root_block_device.value, "volume_type", "gp3")
    }
  }

  # EBS block devices
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
      encrypted             = lookup(ebs_block_device.value, "encrypted", var.enable_encryption)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id           = lookup(ebs_block_device.value, "kms_key_id", var.kms_key_id)
      snapshot_id          = lookup(ebs_block_device.value, "snapshot_id", null)
      tags                 = merge(var.tags, var.ebs_block_device_tags, lookup(ebs_block_device.value, "tags", {}))
      throughput           = lookup(ebs_block_device.value, "throughput", null)
      volume_size          = lookup(ebs_block_device.value, "volume_size", 8)
      volume_type          = lookup(ebs_block_device.value, "volume_type", "gp3")
    }
  }

  # Ephemeral block devices
  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  # Network interfaces
  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  # Launch template
  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  # Enclave options
  dynamic "enclave_options" {
    for_each = var.enclave_options != null ? [var.enclave_options] : []
    content {
      enabled = lookup(enclave_options.value, "enabled", false)
    }
  }

  # Maintenance options
  dynamic "maintenance_options" {
    for_each = var.maintenance_options != null ? [var.maintenance_options] : []
    content {
      auto_recovery = lookup(maintenance_options.value, "auto_recovery", "default")
    }
  }

  # Private DNS name options
  dynamic "private_dns_name_options" {
    for_each = var.private_dns_name_options != null ? [var.private_dns_name_options] : []
    content {
      enable_resource_name_dns_aaaa_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_aaaa_record", false)
      enable_resource_name_dns_a_record    = lookup(private_dns_name_options.value, "enable_resource_name_dns_a_record", false)
      hostname_type                        = lookup(private_dns_name_options.value, "hostname_type", "ip-name")
    }
  }

  # Credit specification for burstable instances
  dynamic "credit_specification" {
    for_each = var.cpu_credits != null ? [var.cpu_credits] : []
    content {
      cpu_credits = credit_specification.value
    }
  }

  # Metadata options
  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", 1)
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "required")
      http_protocol_ipv6          = lookup(metadata_options.value, "http_protocol_ipv6", "disabled")
      instance_metadata_tags      = lookup(metadata_options.value, "instance_metadata_tags", "disabled")
    }
  }

  # Capacity reservation specification
  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", "open")

      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", null) != null ? [lookup(capacity_reservation_specification.value, "capacity_reservation_target")] : []
        content {
          capacity_reservation_id                 = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
          capacity_reservation_resource_group_arn = lookup(capacity_reservation_target.value, "capacity_reservation_resource_group_arn", null)
        }
      }
    }
  }

  tags        = merge(var.tags, var.instance_tags)
  volume_tags = merge(var.tags, var.volume_tags)

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
    ]
  }
}
