# Basic EC2 Instance Example
module "basic_ec2" {
  source = "../../"

  # Required Configuration
  instance_type = "t3.micro"
  environment   = "dev"
  subnet_id     = "subnet-12345678"  # Replace with your subnet ID

  # Basic Tags
  mandatory_tags = {
    Environment = "dev"
    Owner       = "team-dev"
    CostCenter  = "dev-12345"
    Project     = "demo"
  }

  # Basic Security
  vpc_security_group_ids = ["sg-12345678"]  # Replace with your security group ID

  # Use Amazon Linux 2 (default)
  operating_system = "amazon-linux-2"

  # Basic monitoring
  monitoring_config = {
    detailed_monitoring = true
    cpu_threshold      = 80
    memory_threshold   = 80
    disk_threshold     = 85
  }

  # Instance Configuration
  instance_config = {
    backup      = true
    patch_group = "weekly"
  }

  # Tags
  tags = {
    Name = "basic-ec2-instance"
  }
}

# Outputs
output "instance_id" {
  description = "ID of the created instance"
  value       = module.basic_ec2.instance_metrics.instance_id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = module.basic_ec2.instance_metrics.public_ip
}
