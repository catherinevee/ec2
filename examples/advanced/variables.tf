variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "terraform-ec2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "web-app"
}

variable "vpc_name" {
  description = "Name of the VPC to deploy into"
  type        = string
  default     = "default"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "operating_system" {
  description = "Operating system for the EC2 instance"
  type        = string
  default     = "ubuntu-22.04"

  validation {
    condition = contains([
      "amazon-linux-2",
      "amazon-linux-2023",
      "ubuntu-20.04",
      "ubuntu-22.04",
      "ubuntu-24.04",
      "rhel-8",
      "rhel-9",
      "centos-7",
      "windows-2019",
      "windows-2022"
    ], var.operating_system)
    error_message = "Operating system must be one of the supported options."
  }
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = null
}

variable "enable_termination_protection" {
  description = "Enable termination protection"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GB."
  }
}

variable "data_volume_size" {
  description = "Size of the data volume in GB"
  type        = number
  default     = 50

  validation {
    condition     = var.data_volume_size >= 1 && var.data_volume_size <= 16384
    error_message = "Data volume size must be between 1 and 16384 GB."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "terraform-aws-ec2-module"
  }
}
