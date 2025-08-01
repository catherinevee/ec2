# Outputs for private EC2 instance

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.private_ec2.instance_id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.private_ec2.private_ip
}

output "public_ip" {
  description = "Public IP address (should be null for private instance)"
  value       = module.private_ec2.public_ip
}

output "security_group_id" {
  description = "ID of the private instance security group"
  value       = aws_security_group.private_instance.id
}

output "vpc_id" {
  description = "VPC ID where the instance is deployed"
  value       = data.aws_vpc.default.id
}

output "subnet_id" {
  description = "Subnet ID where the instance is deployed"
  value       = data.aws_subnets.default.ids[0]
}

output "vpc_endpoints_created" {
  description = "Whether VPC endpoints were created"
  value       = var.create_vpc_endpoints
}

output "connection_info" {
  description = "Information about connecting to the private instance"
  value = {
    note = "This instance has no public IP and can only be accessed from within the VPC"
    access_methods = [
      "SSH from a bastion host in the same VPC",
      "VPN connection to the VPC",
      "AWS Systems Manager Session Manager",
      "Direct Connect or VPN gateway"
    ]
    ssh_command_from_vpc = var.key_name != null ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.private_ec2.private_ip}" : "No SSH key configured"
  }
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.private_ec2.instance_state
}
