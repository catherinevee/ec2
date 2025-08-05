# AWS EC2 Terraform Module
# Provides EC2 instance configuration with security defaults and production settings
# Default values prioritize security and operational best practices

locals {
  base_tags = merge(
    var.tags,
    try(var.mandatory_tags, {}),
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      CreatedDate    = timestamp()
      BackupEnabled  = try(var.instance_config.backup, true)
      PatchGroup     = try(var.instance_config.patch_group, null)
      ComplianceLevel = var.compliance_level
    }
  )

  monitoring_enabled = coalesce(
    try(var.monitoring_config.detailed_monitoring, null),
    var.monitoring,
    false
  )

  # AMI selection based on operating system
  ami_filters = {
    amazon-linux-2 = {
      owners = ["amazon"]
      filter = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    ubuntu-22-04 = {
      owners = ["099720109477"]
      filter = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    ubuntu-24-04 = {
      owners = ["099720109477"]
      filter = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
    }
    rhel-8 = {
      owners = ["309956199498"]
      filter = ["RHEL-8.*_HVM-*-x86_64-*-Hourly2-GP2"]
    }
    rhel-9 = {
      owners = ["309956199498"]
      filter = ["RHEL-9.*_HVM-*-x86_64-*-Hourly2-GP3"]
    }
    centos-7 = {
      owners = ["125523088429"]
      filter = ["CentOS 7.*x86_64"]
    }
    windows-2019 = {
      owners = ["amazon"]
      filter = ["Windows_Server-2019-English-Full-Base-*"]
    }
    windows-2022 = {
      owners = ["amazon"]
      filter = ["Windows_Server-2022-English-Full-Base-*"]
    }
  }
}

# Main EC2 Instance Resource
resource "aws_instance" "this" {
  # Core Configuration
  ami           = var.ami_id != null ? var.ami_id : data.aws_ami.this[0].id
  instance_type = var.instance_type

  # Security Configuration
  disable_api_termination = var.disable_api_termination
  iam_instance_profile   = var.iam_instance_profile
  monitoring            = local.monitoring_enabled
  
  # Network Configuration
  subnet_id                   = var.subnet_id
  vpc_security_group_ids     = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                 = var.private_ip
  secondary_private_ips      = var.secondary_private_ips
  ipv6_address_count        = var.ipv6_address_count
  ipv6_addresses            = var.ipv6_addresses

  # Instance Metadata Configuration
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.compliance_level == "pci" ? "required" : try(var.metadata_options.http_tokens, "required")
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # Root Block Device Configuration
  root_block_device {
    encrypted   = true
    volume_type = try(var.root_block_device.volume_type, "gp3")
    volume_size = try(var.root_block_device.volume_size, 20)
    tags        = local.base_tags
  }

  # Tags
  tags = merge(
    local.base_tags,
    var.instance_tags,
    {
      Name = coalesce(try(var.instance_tags["Name"], null), "ec2-${var.environment}")
    }
  )

  # Lifecycle Rules
  lifecycle {
    precondition {
      condition     = var.environment != "prod" || !can(regex("^t[0-9]\\.", var.instance_type))
      error_message = "Production environment cannot use t-series instances"
    }
    
    precondition {
      condition     = var.compliance_level != "pci" || var.enable_encryption
      error_message = "PCI compliance requires encryption to be enabled"
    }
  }

  # Additional EBS block devices
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
      device_name          = ebs_block_device.value.device_name
      encrypted            = lookup(ebs_block_device.value, "encrypted", true)
      iops                = lookup(ebs_block_device.value, "iops", null)
      kms_key_id          = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id         = lookup(ebs_block_device.value, "snapshot_id", null)
      throughput          = lookup(ebs_block_device.value, "throughput", null)
      volume_size         = lookup(ebs_block_device.value, "volume_size", null)
      volume_type         = lookup(ebs_block_device.value, "volume_type", "gp3")
      tags               = lookup(ebs_block_device.value, "tags", null)
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

  volume_tags = merge(var.tags, var.volume_tags)

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
    ]
  }
}

# Data source for AMI selection
data "aws_ami" "this" {
  count = var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = try(local.ami_filters[var.operating_system].owners, ["amazon"])

  filter {
    name   = "name"
    values = try(local.ami_filters[var.operating_system].filter, ["amzn2-ami-hvm-*-x86_64-gp2"])
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
