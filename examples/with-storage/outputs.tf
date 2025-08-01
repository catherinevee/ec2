# Outputs for EC2 instance with custom storage

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_with_storage.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_with_storage.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_with_storage.private_ip
}

output "root_volume_id" {
  description = "ID of the root EBS volume"
  value       = module.ec2_with_storage.root_block_device_volume_ids
}

output "additional_volume_ids" {
  description = "IDs of additional EBS volumes"
  value       = module.ec2_with_storage.ebs_block_device_volume_ids
}

output "storage_configuration" {
  description = "Summary of storage configuration"
  value = {
    root_volume = {
      type       = var.root_volume_type
      size_gb    = var.root_volume_size
      iops       = var.root_volume_type == "gp3" ? var.root_volume_iops : null
      throughput = var.root_volume_type == "gp3" ? var.root_volume_throughput : null
      encrypted  = true
    }
    data_volume = {
      type       = var.data_volume_type
      size_gb    = var.data_volume_size
      iops       = var.data_volume_type == "gp3" ? var.data_volume_iops : null
      throughput = var.data_volume_type == "gp3" ? var.data_volume_throughput : null
      encrypted  = true
      mount_point = "/data"
    }
    log_volume = var.create_log_volume ? {
      type        = "gp3"
      size_gb     = var.log_volume_size
      iops        = 3000
      throughput  = 125
      encrypted   = true
      mount_point = "/logs"
    } : null
    ebs_optimized = var.ebs_optimized
  }
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance (if key pair is provided)"
  value       = var.key_name != null ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2_with_storage.public_ip}" : "No SSH key pair configured"
}

output "storage_commands" {
  description = "Useful commands to check storage status on the instance"
  value = {
    check_volumes    = "lsblk"
    check_mounts     = "df -h"
    check_fstab      = "cat /etc/fstab"
    storage_status   = "cat /home/ec2-user/storage_status.txt"
    data_directory   = "ls -la /data"
    logs_directory   = var.create_log_volume ? "ls -la /logs" : "Log volume not created"
  }
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.ec2_with_storage.instance_state
}
