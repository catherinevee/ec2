# Enhanced Instance Outputs
output "instance_metrics" {
  description = "Map of instance metrics and monitoring information"
  value = {
    instance_id     = aws_instance.this.id
    instance_state  = aws_instance.this.instance_state
    monitoring      = aws_instance.this.monitoring
    ebs_optimized   = aws_instance.this.ebs_optimized
    private_ip      = aws_instance.this.private_ip
    public_ip       = aws_instance.this.public_ip
    security_groups = aws_instance.this.vpc_security_group_ids
    arn            = aws_instance.this.arn
  }
}

output "instance_compliance" {
  description = "Compliance and security information"
  value = {
    compliance_level   = var.compliance_level
    encryption_enabled = var.enable_encryption
    imdsv2_required   = var.metadata_options != null ? var.metadata_options.http_tokens == "required" : true
    monitoring_config  = var.monitoring_config
  }
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = aws_instance.this.outpost_arn
}

output "storage_configuration" {
  description = "Storage configuration details"
  value = {
    root_volume = {
      device_name = aws_instance.this.root_block_device[0].device_name
      volume_id   = aws_instance.this.root_block_device[0].volume_id
      volume_size = aws_instance.this.root_block_device[0].volume_size
      encrypted   = aws_instance.this.root_block_device[0].encrypted
    }
    ebs_volumes = [
      for vol in aws_instance.this.ebs_block_device : {
        device_name = vol.device_name
        volume_id   = vol.volume_id
        volume_size = vol.volume_size
        encrypted   = vol.encrypted
      }
    ]
  }
}

output "network_configuration" {
  description = "Network configuration details"
  value = {
    subnet_id                   = aws_instance.this.subnet_id
    vpc_security_group_ids     = aws_instance.this.vpc_security_group_ids
    private_ip                 = aws_instance.this.private_ip
    public_ip                  = aws_instance.this.public_ip
    associate_public_ip_address = aws_instance.this.associate_public_ip_address
    primary_network_interface_id = aws_instance.this.primary_network_interface_id
  }
}

output "sensitive_data" {
  description = "Sensitive instance data"
  value = {
    password_data = aws_instance.this.password_data
  }
  sensitive = true
}

output "private_dns_name_options" {
  description = "The metadata options for the instance"
  value       = aws_instance.this.private_dns_name_options
}

output "public_dns" {
  description = "The public DNS name assigned to the instance"
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = aws_instance.this.public_ip
}

output "private_dns" {
  description = "The private DNS name assigned to the instance"
  value       = aws_instance.this.private_dns
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "ipv6_addresses" {
  description = "The IPv6 address assigned to the instance"
  value       = aws_instance.this.ipv6_addresses
}

output "tags_all" {
  description = "A map of tags assigned to the resource"
  value       = aws_instance.this.tags_all
}

# Security Group Outputs
output "vpc_security_group_ids" {
  description = "The associated security groups in VPC"
  value       = aws_instance.this.vpc_security_group_ids
}

output "security_groups" {
  description = "The associated security groups"
  value       = aws_instance.this.security_groups
}

# Network Outputs
output "subnet_id" {
  description = "The VPC subnet ID"
  value       = aws_instance.this.subnet_id
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "placement_group" {
  description = "The placement group of the instance"
  value       = aws_instance.this.placement_group
}

output "placement_partition_number" {
  description = "The number of the partition the instance is in"
  value       = aws_instance.this.placement_partition_number
}

# Instance Configuration Outputs
output "instance_type" {
  description = "The type of instance"
  value       = aws_instance.this.instance_type
}

output "ami" {
  description = "ID of AMI used to launch the instance"
  value       = aws_instance.this.ami
}

output "key_name" {
  description = "The key name of the instance"
  value       = aws_instance.this.key_name
}

output "monitoring" {
  description = "Whether detailed monitoring is enabled"
  value       = aws_instance.this.monitoring
}

output "get_password_data" {
  description = "Whether or not password data is being retrieved"
  value       = aws_instance.this.get_password_data
}

output "ebs_optimized" {
  description = "Whether the instance is EBS optimized"
  value       = aws_instance.this.ebs_optimized
}

output "disable_api_termination" {
  description = "Whether termination protection is enabled"
  value       = aws_instance.this.disable_api_termination
}

output "disable_api_stop" {
  description = "Whether stop protection is enabled"
  value       = aws_instance.this.disable_api_stop
}

output "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  value       = aws_instance.this.instance_initiated_shutdown_behavior
}

output "tenancy" {
  description = "The tenancy of the instance"
  value       = aws_instance.this.tenancy
}

output "host_id" {
  description = "The Id of the dedicated host the instance will be assigned to"
  value       = aws_instance.this.host_id
}

output "host_resource_group_arn" {
  description = "The ARN of the host resource group in which the instance was launched"
  value       = aws_instance.this.host_resource_group_arn
}

output "cpu_threads_per_core" {
  description = "The number of CPU threads per core for the instance"
  value       = aws_instance.this.cpu_threads_per_core
}

output "cpu_core_count" {
  description = "The number of CPU cores for the instance"
  value       = aws_instance.this.cpu_core_count
}

# Storage Outputs
output "root_block_device" {
  description = "Root block device information"
  value       = aws_instance.this.root_block_device
}

output "ebs_block_device" {
  description = "EBS block device information"
  value       = aws_instance.this.ebs_block_device
}

output "ephemeral_block_device" {
  description = "Ephemeral block device information"
  value       = aws_instance.this.ephemeral_block_device
}

# IAM Outputs
output "iam_instance_profile" {
  description = "The IAM instance profile associated with the instance"
  value       = aws_instance.this.iam_instance_profile
}

# Metadata Outputs
output "metadata_options" {
  description = "The metadata options for the instance"
  value       = aws_instance.this.metadata_options
}

output "enclave_options" {
  description = "The enclave options for the instance"
  value       = aws_instance.this.enclave_options
}

output "maintenance_options" {
  description = "The maintenance options for the instance"
  value       = aws_instance.this.maintenance_options
}

output "capacity_reservation_specification" {
  description = "The capacity reservation specification for the instance"
  value       = aws_instance.this.capacity_reservation_specification
}
