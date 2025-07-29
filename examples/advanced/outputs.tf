output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.web_server.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = module.web_server.arn
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.web_server.private_ip
}

output "instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = module.web_server.private_dns
}

output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = module.web_server.availability_zone
}

output "instance_subnet_id" {
  description = "Subnet ID of the EC2 instance"
  value       = module.web_server.subnet_id
}

output "instance_security_groups" {
  description = "Security groups associated with the EC2 instance"
  value       = module.web_server.vpc_security_group_ids
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.arn
}
