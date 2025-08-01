# Outputs for tagged EC2 instance

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.tagged_ec2.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.tagged_ec2.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.tagged_ec2.private_ip
}

output "instance_tags" {
  description = "All tags applied to the instance"
  value       = module.tagged_ec2.tags_all
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance (if key pair is provided)"
  value       = var.key_name != null ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.tagged_ec2.public_ip}" : "No SSH key pair configured"
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.tagged_ec2.instance_state
}

output "cost_allocation_tags" {
  description = "Key cost allocation tags for billing reports"
  value = {
    CostCenter     = var.cost_center
    Department     = var.department
    Environment    = var.environment
    Project        = var.project_name
    BillingProject = var.billing_project
  }
}
