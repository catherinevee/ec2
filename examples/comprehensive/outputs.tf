# ==============================================================================
# COMPREHENSIVE EC2 EXAMPLE OUTPUTS
# ==============================================================================
# Outputs demonstrating the extensive information available from the enhanced EC2 module

# ==============================================================================
# INSTANCE INFORMATION
# ==============================================================================

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_comprehensive.instance_id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = module.ec2_comprehensive.instance_arn
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.ec2_comprehensive.instance_state
}

output "instance_type" {
  description = "Type of the EC2 instance"
  value       = module.ec2_comprehensive.instance_type
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = module.ec2_comprehensive.ami_id
}

# ==============================================================================
# NETWORK INFORMATION
# ==============================================================================

output "public_ip" {
  description = "Public IP address of the instance"
  value       = module.ec2_comprehensive.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = module.ec2_comprehensive.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = module.ec2_comprehensive.public_dns
}

output "private_dns" {
  description = "Private DNS name of the instance"
  value       = module.ec2_comprehensive.private_dns
}

output "subnet_id" {
  description = "Subnet ID where the instance is placed"
  value       = module.ec2_comprehensive.subnet_id
}

output "vpc_security_group_ids" {
  description = "Security group IDs attached to the instance"
  value       = module.ec2_comprehensive.vpc_security_group_ids
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = module.ec2_comprehensive.availability_zone
}

# ==============================================================================
# STORAGE INFORMATION
# ==============================================================================

output "root_block_device" {
  description = "Root block device information"
  value       = module.ec2_comprehensive.root_block_device
  sensitive   = false
}

output "ebs_block_device" {
  description = "EBS block device information"
  value       = module.ec2_comprehensive.ebs_block_device
  sensitive   = false
}

# ==============================================================================
# SECURITY AND ACCESS
# ==============================================================================

output "key_name" {
  description = "Key pair name used for the instance"
  value       = module.ec2_comprehensive.key_name
}

output "iam_instance_profile" {
  description = "IAM instance profile attached to the instance"
  value       = module.ec2_comprehensive.iam_instance_profile
}

output "security_groups" {
  description = "Security groups attached to the instance"
  value       = module.ec2_comprehensive.security_groups
}

# ==============================================================================
# PERFORMANCE AND MONITORING
# ==============================================================================

output "monitoring" {
  description = "Monitoring status of the instance"
  value       = module.ec2_comprehensive.monitoring
}

output "ebs_optimized" {
  description = "EBS optimization status"
  value       = module.ec2_comprehensive.ebs_optimized
}

output "cpu_core_count" {
  description = "Number of CPU cores"
  value       = module.ec2_comprehensive.cpu_core_count
}

output "cpu_threads_per_core" {
  description = "Number of threads per CPU core"
  value       = module.ec2_comprehensive.cpu_threads_per_core
}

# ==============================================================================
# ADVANCED CONFIGURATION
# ==============================================================================

output "placement_group" {
  description = "Placement group of the instance"
  value       = module.ec2_comprehensive.placement_group
}

output "placement_partition_number" {
  description = "Placement partition number"
  value       = module.ec2_comprehensive.placement_partition_number
}

output "tenancy" {
  description = "Tenancy of the instance"
  value       = module.ec2_comprehensive.tenancy
}

output "hibernation" {
  description = "Hibernation support status"
  value       = module.ec2_comprehensive.hibernation
}

# ==============================================================================
# TAGS AND METADATA
# ==============================================================================

output "tags" {
  description = "Tags applied to the instance"
  value       = module.ec2_comprehensive.tags
}

output "tags_all" {
  description = "All tags applied to the instance (including provider defaults)"
  value       = module.ec2_comprehensive.tags_all
}

# ==============================================================================
# ENCRYPTION AND COMPLIANCE
# ==============================================================================

output "kms_key_id" {
  description = "KMS key ID used for encryption"
  value       = aws_kms_key.ec2.id
}

output "kms_key_arn" {
  description = "KMS key ARN used for encryption"
  value       = aws_kms_key.ec2.arn
}

# ==============================================================================
# CONNECTION INFORMATION
# ==============================================================================

output "ssh_connection_command" {
  description = "SSH connection command for Linux instances"
  value = var.key_name != null && module.ec2_comprehensive.public_ip != null ? (
    contains(["windows-2019", "windows-2022"], var.operating_system) ? 
    "Use RDP to connect to ${module.ec2_comprehensive.public_ip}" :
    "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2_comprehensive.public_ip}"
  ) : "No key pair specified or no public IP available"
}

output "instance_connect_command" {
  description = "AWS EC2 Instance Connect command"
  value = module.ec2_comprehensive.public_ip != null ? (
    "aws ec2-instance-connect send-ssh-public-key --instance-id ${module.ec2_comprehensive.instance_id} --availability-zone ${module.ec2_comprehensive.availability_zone} --instance-os-user ec2-user --ssh-public-key file://~/.ssh/id_rsa.pub"
  ) : "No public IP available for Instance Connect"
}

# ==============================================================================
# COST OPTIMIZATION INFORMATION
# ==============================================================================

output "cost_optimization_recommendations" {
  description = "Cost optimization recommendations"
  value = {
    instance_type = "Consider using Spot instances for non-critical workloads"
    storage = "Use gp3 volumes for better price/performance ratio"
    monitoring = "Detailed monitoring incurs additional charges"
    hibernation = var.hibernation ? "Hibernation can reduce costs for intermittent workloads" : "Consider enabling hibernation for cost savings"
  }
}

# ==============================================================================
# SECURITY RECOMMENDATIONS
# ==============================================================================

output "security_status" {
  description = "Security configuration status"
  value = {
    imdsv2_enforced = "✓ IMDSv2 enforced for enhanced security"
    encryption_enabled = "✓ EBS volumes encrypted with customer-managed KMS key"
    termination_protection = var.disable_api_termination ? "✓ Termination protection enabled" : "⚠ Consider enabling termination protection"
    iam_profile = "✓ IAM instance profile attached for secure access"
    monitoring = "✓ Enhanced monitoring enabled"
  }
}
