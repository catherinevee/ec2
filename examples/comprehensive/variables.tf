# ==============================================================================
# COMPREHENSIVE EC2 EXAMPLE VARIABLES
# ==============================================================================
# Variables for demonstrating maximum customizability of the EC2 module

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be in the format: us-west-2, eu-west-1, etc."
  }
}

variable "project_name" {
  description = "Name of the project for resource naming and tagging"
  type        = string
  default     = "ec2-comprehensive-demo"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "demo"
  validation {
    condition     = contains(["dev", "staging", "prod", "demo"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, demo."
  }
}

# ==============================================================================
# CORE INSTANCE CONFIGURATION
# ==============================================================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "operating_system" {
  description = "Operating system for the instance"
  type        = string
  default     = "amazon-linux-2"
  validation {
    condition = contains([
      "amazon-linux-2", "amazon-linux-2023", "ubuntu-20.04", "ubuntu-22.04",
      "rhel-8", "rhel-9", "windows-2019", "windows-2022"
    ], var.operating_system)
    error_message = "Operating system must be a supported value."
  }
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
  default     = null
}

# ==============================================================================
# NETWORK CONFIGURATION
# ==============================================================================

variable "private_ip" {
  description = "Private IP address to assign to the instance"
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "List of secondary private IP addresses"
  type        = list(string)
  default     = []
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to assign"
  type        = number
  default     = 0
  validation {
    condition     = var.ipv6_address_count >= 0 && var.ipv6_address_count <= 16
    error_message = "IPv6 address count must be between 0 and 16."
  }
}

variable "ipv6_addresses" {
  description = "List of IPv6 addresses to assign"
  type        = list(string)
  default     = []
}

# ==============================================================================
# SECURITY CONFIGURATION
# ==============================================================================

variable "disable_api_termination" {
  description = "Enable termination protection"
  type        = bool
  default     = true
}

variable "disable_api_stop" {
  description = "Enable stop protection"
  type        = bool
  default     = false
}

# ==============================================================================
# PERFORMANCE CONFIGURATION
# ==============================================================================

variable "cpu_options" {
  description = "CPU options for the instance"
  type = object({
    core_count       = optional(number)
    threads_per_core = optional(number)
    amd_sev_snp     = optional(string)
  })
  default = null
}

variable "credit_specification" {
  description = "Credit specification for burstable instances"
  type = object({
    cpu_credits = optional(string, "standard")
  })
  default = null
}

# ==============================================================================
# PLACEMENT AND TENANCY
# ==============================================================================

variable "availability_zone" {
  description = "Availability zone for the instance"
  type        = string
  default     = null
}

variable "placement_group" {
  description = "Placement group name"
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "Partition number for partition placement groups"
  type        = number
  default     = null
}

variable "tenancy" {
  description = "Tenancy of the instance"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "Tenancy must be one of: default, dedicated, host."
  }
}

variable "host_id" {
  description = "ID of the dedicated host"
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "ARN of the host resource group"
  type        = string
  default     = null
}

# ==============================================================================
# STORAGE CONFIGURATION
# ==============================================================================

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GB."
  }
}

variable "root_volume_iops" {
  description = "IOPS for the root volume (gp3/io1/io2 only)"
  type        = number
  default     = 3000
}

variable "root_volume_throughput" {
  description = "Throughput for the root volume in MB/s (gp3 only)"
  type        = number
  default     = 125
}

variable "additional_volumes" {
  description = "Additional EBS volumes to attach"
  type = list(object({
    device_name           = string
    volume_size          = optional(number, 10)
    volume_type          = optional(string, "gp3")
    iops                 = optional(number)
    throughput           = optional(number)
    encrypted            = optional(bool, true)
    kms_key_id          = optional(string)
    delete_on_termination = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = []
}

# ==============================================================================
# ADVANCED FEATURES
# ==============================================================================

variable "hibernation" {
  description = "Enable hibernation support"
  type        = bool
  default     = false
}

variable "enclave_options" {
  description = "Nitro Enclave options"
  type = object({
    enabled = optional(bool, false)
  })
  default = null
}

variable "enable_resource_name_dns" {
  description = "Enable resource name DNS A record"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_ipv6" {
  description = "Enable resource name DNS AAAA record"
  type        = bool
  default     = false
}

variable "hostname_type" {
  description = "Type of hostname for the instance"
  type        = string
  default     = "ip-name"
  validation {
    condition     = contains(["ip-name", "resource-name"], var.hostname_type)
    error_message = "Hostname type must be either 'ip-name' or 'resource-name'."
  }
}

# ==============================================================================
# USER DATA AND INITIALIZATION
# ==============================================================================

variable "user_data" {
  description = "User data script for instance initialization"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64 encoded user data"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Replace instance when user data changes"
  type        = bool
  default     = false
}

variable "get_password_data" {
  description = "Retrieve Windows password data"
  type        = bool
  default     = false
}

variable "shutdown_behavior" {
  description = "Instance shutdown behavior"
  type        = string
  default     = "stop"
  validation {
    condition     = contains(["stop", "terminate"], var.shutdown_behavior)
    error_message = "Shutdown behavior must be either 'stop' or 'terminate'."
  }
}

# ==============================================================================
# TAGGING
# ==============================================================================

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
