# Outputs for web server instance

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.web_server.instance_id
}

output "public_ip" {
  description = "Public IP address of the web server"
  value       = module.web_server.public_ip
}

output "private_ip" {
  description = "Private IP address of the web server"
  value       = module.web_server.private_ip
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${module.web_server.public_ip}"
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance (if key pair is provided)"
  value       = var.key_name != null ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.web_server.public_ip}" : "No SSH key pair configured"
}

output "security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web_server.id
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = module.web_server.instance_state
}
