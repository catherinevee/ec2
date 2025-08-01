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

# Root volume configuration
variable "root_volume_type" {
  description = "Type of root volume (gp3, gp2, io1, io2)"
  type        = string
  default     = "gp3"
  
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Root volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
  
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GB."
  }
}

variable "root_volume_iops" {
  description = "IOPS for root volume (only for gp3, io1, io2)"
  type        = number
  default     = 3000
}

variable "root_volume_throughput" {
  description = "Throughput for root volume in MB/s (only for gp3)"
  type        = number
  default     = 125
}

# Data volume configuration
variable "data_volume_type" {
  description = "Type of data volume (gp3, gp2, io1, io2)"
  type        = string
  default     = "gp3"
  
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.data_volume_type)
    error_message = "Data volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "data_volume_size" {
  description = "Size of data volume in GB"
  type        = number
  default     = 50
  
  validation {
    condition     = var.data_volume_size >= 1 && var.data_volume_size <= 16384
    error_message = "Data volume size must be between 1 and 16384 GB."
  }
}

variable "data_volume_iops" {
  description = "IOPS for data volume (only for gp3, io1, io2)"
  type        = number
  default     = 3000
}

variable "data_volume_throughput" {
  description = "Throughput for data volume in MB/s (only for gp3)"
  type        = number
  default     = 125
}

# Log volume configuration
variable "create_log_volume" {
  description = "Whether to create a separate log volume"
  type        = bool
  default     = false
}

variable "log_volume_size" {
  description = "Size of log volume in GB"
  type        = number
  default     = 20
  
  validation {
    condition     = var.log_volume_size >= 1 && var.log_volume_size <= 16384
    error_message = "Log volume size must be between 1 and 16384 GB."
  }
}

# General storage options
variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = true
}

variable "delete_volumes_on_termination" {
  description = "Whether to delete additional volumes when instance is terminated"
  type        = bool
  default     = true
}
