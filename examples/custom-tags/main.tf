# EC2 Instance with Custom Tags Example
# This example demonstrates comprehensive tagging strategies for EC2 instances

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Default tags applied to all resources
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      CreatedBy   = var.created_by
      CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
    }
  }
}

# Data sources for networking
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# EC2 instance with comprehensive tagging
module "tagged_ec2" {
  source = "../../"

  # Required
  instance_type = var.instance_type

  # Optional configuration
  key_name   = var.key_name
  monitoring = true

  # Networking
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids     = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  # Comprehensive tagging strategy
  tags = {
    # Identity and ownership
    Name        = "${var.project_name}-${var.environment}-instance"
    Owner       = var.owner
    Team        = var.team
    Contact     = var.contact_email

    # Environment and lifecycle
    Environment = var.environment
    Lifecycle   = var.lifecycle
    
    # Cost management
    CostCenter     = var.cost_center
    Department     = var.department
    BillingProject = var.billing_project
    
    # Technical details
    Application = var.application_name
    Service     = var.service_name
    Component   = var.component
    Version     = var.application_version
    
    # Operational
    BackupRequired    = var.backup_required
    MonitoringLevel   = var.monitoring_level
    MaintenanceWindow = var.maintenance_window
    
    # Compliance and security
    DataClassification = var.data_classification
    ComplianceScope    = var.compliance_scope
    SecurityLevel      = var.security_level
    
    # Automation
    AutoStart = var.auto_start
    AutoStop  = var.auto_stop
    
    # Custom business tags
    BusinessUnit = var.business_unit
    Purpose      = var.purpose
    Criticality  = var.criticality
  }
}
