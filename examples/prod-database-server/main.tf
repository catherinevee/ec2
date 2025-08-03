# Production Database Server Example
module "prod_db_server" {
  source = "../../"

  # Instance Configuration
  instance_type = "m5.xlarge"
  environment   = "prod"

  # Networking - Place in private subnet
  subnet_id               = "subnet-12345678"  # Replace with your private subnet ID
  vpc_security_group_ids = ["sg-12345678"]    # Replace with your security group ID

  # Operating System
  operating_system = "amazon-linux-2"

  # Enhanced Storage Configuration
  root_block_device = {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
    iops        = 3000
    throughput  = 125
  }

  # Additional EBS Volumes for Database
  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "io2"
      volume_size = 200
      encrypted   = true
      iops        = 5000
    },
    {
      device_name = "/dev/sdg"
      volume_type = "io2"
      volume_size = 500
      encrypted   = true
      iops        = 5000
    }
  ]

  # Mandatory Tags
  mandatory_tags = {
    Environment = "prod"
    Owner       = "dba-team"
    CostCenter  = "prod-db-456"
    Project     = "main-database"
  }

  # Additional Tags
  tags = {
    Name           = "prod-db-server"
    Application    = "postgresql"
    Role           = "database"
    BackupSchedule = "daily"
  }

  # Enhanced Monitoring for Production
  monitoring_config = {
    detailed_monitoring = true
    cpu_threshold      = 60  # Lower threshold for production
    memory_threshold   = 60
    disk_threshold     = 75
    alert_endpoints    = ["database-alerts@example.com"]
  }

  # Production Instance Settings
  instance_config = {
    monitoring    = true
    ebs_optimized = true
    backup        = true
    patch_group   = "prod-db-monthly"
  }

  # Enhanced Security Settings
  compliance_level         = "pci"  # Enable PCI compliance checks
  disable_api_termination = true   # Protect against accidental termination
}

# Outputs
output "db_server_id" {
  description = "ID of the database server"
  value       = module.prod_db_server.instance_metrics.instance_id
}

output "db_storage_config" {
  description = "Storage configuration details"
  value       = module.prod_db_server.storage_configuration
}

output "db_server_metrics" {
  description = "Database server monitoring metrics"
  value       = module.prod_db_server.instance_metrics
}

output "db_compliance_info" {
  description = "Compliance and security information"
  value       = module.prod_db_server.instance_compliance
}
