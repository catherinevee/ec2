variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair (optional)"
  type        = string
  default     = null
}

# Project and Environment
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# Ownership and Contact
variable "owner" {
  description = "Owner of the resource"
  type        = string
  default     = "DevOps Team"
}

variable "team" {
  description = "Team responsible for the resource"
  type        = string
  default     = "Platform"
}

variable "contact_email" {
  description = "Contact email for the resource"
  type        = string
  default     = "devops@company.com"
}

variable "created_by" {
  description = "Who created this resource"
  type        = string
  default     = "terraform-user"
}

# Cost Management
variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "IT-001"
}

variable "department" {
  description = "Department owning the resource"
  type        = string
  default     = "Engineering"
}

variable "billing_project" {
  description = "Project for billing purposes"
  type        = string
  default     = "infrastructure"
}

# Application Details
variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "web-app"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "backend"
}

variable "component" {
  description = "Component within the service"
  type        = string
  default     = "api-server"
}

variable "application_version" {
  description = "Version of the application"
  type        = string
  default     = "1.0.0"
}

# Operational
variable "lifecycle" {
  description = "Lifecycle stage of the resource"
  type        = string
  default     = "active"
}

variable "backup_required" {
  description = "Whether backup is required"
  type        = string
  default     = "true"
}

variable "monitoring_level" {
  description = "Level of monitoring required"
  type        = string
  default     = "standard"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "Sunday 02:00-04:00 UTC"
}

# Compliance and Security
variable "data_classification" {
  description = "Data classification level"
  type        = string
  default     = "internal"
}

variable "compliance_scope" {
  description = "Compliance requirements"
  type        = string
  default     = "none"
}

variable "security_level" {
  description = "Security level required"
  type        = string
  default     = "standard"
}

# Automation
variable "auto_start" {
  description = "Auto start schedule"
  type        = string
  default     = "weekdays-8am"
}

variable "auto_stop" {
  description = "Auto stop schedule"
  type        = string
  default     = "weekdays-6pm"
}

# Business
variable "business_unit" {
  description = "Business unit"
  type        = string
  default     = "Technology"
}

variable "purpose" {
  description = "Purpose of the resource"
  type        = string
  default     = "Development and testing"
}

variable "criticality" {
  description = "Business criticality"
  type        = string
  default     = "medium"
  
  validation {
    condition     = contains(["low", "medium", "high", "critical"], var.criticality)
    error_message = "Criticality must be one of: low, medium, high, critical."
  }
}
