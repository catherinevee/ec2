# Outputs for EC2 instance with SSH access

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_with_keypair.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_with_keypair.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_with_keypair.private_ip
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2_with_keypair.public_ip}"
}

output "security_group_id" {
  description = "ID of the security group allowing SSH access"
  value       = aws_security_group.ssh_access.id
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.ec2_with_keypair.instance_state
}
