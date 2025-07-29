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

# EC2 Instance
resource "aws_instance" "this" {
  ami                                  = var.ami_id != null ? var.ami_id : data.aws_ami.this[0].id
  instance_type                        = var.instance_type
  key_name                            = var.key_name
  vpc_security_group_ids              = var.vpc_security_group_ids
  subnet_id                           = var.subnet_id
  availability_zone                   = var.availability_zone
  associate_public_ip_address         = var.associate_public_ip_address
  private_ip                          = var.private_ip
  secondary_private_ips               = var.secondary_private_ips
  ipv6_address_count                  = var.ipv6_address_count
  ipv6_addresses                      = var.ipv6_addresses
  ebs_optimized                       = var.ebs_optimized
  disable_api_termination             = var.disable_api_termination
  disable_api_stop                    = var.disable_api_stop
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                     = var.placement_group
  placement_partition_number          = var.placement_partition_number
  tenancy                             = var.tenancy
  host_id                             = var.host_id
  host_resource_group_arn             = var.host_resource_group_arn
  cpu_threads_per_core                = var.cpu_threads_per_core
  cpu_core_count                      = var.cpu_core_count
  hibernation                         = var.hibernation
  user_data                           = var.user_data
  user_data_base64                    = var.user_data_base64
  user_data_replace_on_change         = var.user_data_replace_on_change
  get_password_data                   = var.get_password_data
  monitoring                          = var.monitoring
  iam_instance_profile                = var.iam_instance_profile
  source_dest_check                   = var.source_dest_check

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
