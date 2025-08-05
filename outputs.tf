# Instance Outputs
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
