# Outputs for minimal EC2 instance

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.minimal_ec2.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.minimal_ec2.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.minimal_ec2.private_ip
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.minimal_ec2.instance_state
}
