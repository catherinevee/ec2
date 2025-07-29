# Required Variables
variable "instance_type" {
  description = "The type of instance to start"
  type        = string

  validation {
    condition = can(regex("^[a-z][0-9][a-z]?\\.[a-z0-9]+$", var.instance_type))
    error_message = "Instance type must be a valid EC2 instance type (e.g., t3.micro, m5.large)."
  }
}

# Optional Variables - Instance Configuration
variable "ami_id" {
  description = "ID of AMI to use for the instance. If null, will use data source to find latest AMI"
  type        = string
  default     = null
}

variable "ami_owners" {
  description = "List of AMI owners to limit search. Used when ami_id is null"
  type        = list(string)
  default     = ["amazon"]
}

variable "ami_name_filter" {
  description = "List of AMI name patterns to filter by. Used when ami_id is null"
  type        = list(string)
  default     = ["amzn2-ami-hvm-*-x86_64-gp2"]
}

variable "operating_system" {
  description = "Operating system for the EC2 instance. Automatically selects appropriate AMI when ami_id is null"
  type        = string
  default     = "amazon-linux-2"

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
    error_message = "Operating system must be one of: amazon-linux-2, amazon-linux-2023, ubuntu-20.04, ubuntu-22.04, ubuntu-24.04, rhel-8, rhel-9, centos-7, windows-2019, windows-2022."
  }
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The AZ to start the instance in"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "A list of secondary private IP addresses to assign to the instance's primary network interface"
  type        = list(string)
  default     = []
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = []
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  default     = "stop"

  validation {
    condition     = contains(["stop", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "Instance initiated shutdown behavior must be either 'stop' or 'terminate'."
  }
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "The number of the partition the instance is in"
  type        = number
  default     = null
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC)"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "Tenancy must be one of: default, dedicated, host."
  }
}

variable "host_id" {
  description = "The Id of a dedicated host that the instance will be assigned to"
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "The ARN of the host resource group in which to launch the instances"
  type        = string
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance"
  type        = number
  default     = null
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance"
  type        = number
  default     = null
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = null

  validation {
    condition = var.cpu_credits == null || contains(["standard", "unlimited"], var.cpu_credits)
    error_message = "CPU credits must be either 'standard' or 'unlimited'."
  }
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true"
  type        = bool
  default     = false
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance"
  type        = bool
  default     = true
}

# Storage Configuration
variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type = object({
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id           = optional(string)
    tags                 = optional(map(string), {})
    throughput           = optional(number)
    volume_size          = optional(number, 8)
    volume_type          = optional(string, "gp3")
  })
  default = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id           = optional(string)
    snapshot_id          = optional(string)
    tags                 = optional(map(string), {})
    throughput           = optional(number)
    volume_size          = optional(number, 8)
    volume_type          = optional(string, "gp3")
  }))
  default = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type = list(object({
    device_index          = number
    network_interface_id  = optional(string)
    delete_on_termination = optional(bool, false)
  }))
  default = []
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance"
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null
}

# Security and Encryption
variable "enable_encryption" {
  description = "Enable encryption for EBS volumes"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume"
  type        = string
  default     = null
}

variable "enclave_options" {
  description = "Enable Nitro Enclaves on launched instances"
  type = object({
    enabled = optional(bool, false)
  })
  default = null
}

variable "maintenance_options" {
  description = "The maintenance options for the instance"
  type = object({
    auto_recovery = optional(string, "default")
  })
  default = null

  validation {
    condition = var.maintenance_options == null || contains(["default", "disabled"], var.maintenance_options.auto_recovery)
    error_message = "Auto recovery must be either 'default' or 'disabled'."
  }
}

variable "private_dns_name_options" {
  description = "The options for the instance hostname"
  type = object({
    enable_resource_name_dns_aaaa_record = optional(bool, false)
    enable_resource_name_dns_a_record    = optional(bool, false)
    hostname_type                        = optional(string, "ip-name")
  })
  default = null

  validation {
    condition = var.private_dns_name_options == null || contains(["ip-name", "resource-name"], var.private_dns_name_options.hostname_type)
    error_message = "Hostname type must be either 'ip-name' or 'resource-name'."
  }
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_put_response_hop_limit = optional(number, 1)
    http_tokens                 = optional(string, "required")
    http_protocol_ipv6          = optional(string, "disabled")
    instance_metadata_tags      = optional(string, "disabled")
  })
  default = null

  validation {
    condition = var.metadata_options == null || contains(["enabled", "disabled"], var.metadata_options.http_endpoint)
    error_message = "HTTP endpoint must be either 'enabled' or 'disabled'."
  }

  validation {
    condition = var.metadata_options == null || contains(["optional", "required"], var.metadata_options.http_tokens)
    error_message = "HTTP tokens must be either 'optional' or 'required'."
  }

  validation {
    condition = var.metadata_options == null || contains(["enabled", "disabled"], var.metadata_options.http_protocol_ipv6)
    error_message = "HTTP protocol IPv6 must be either 'enabled' or 'disabled'."
  }

  validation {
    condition = var.metadata_options == null || contains(["enabled", "disabled"], var.metadata_options.instance_metadata_tags)
    error_message = "Instance metadata tags must be either 'enabled' or 'disabled'."
  }
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type = object({
    capacity_reservation_preference = optional(string, "open")
    capacity_reservation_target = optional(object({
      capacity_reservation_id                 = optional(string)
      capacity_reservation_resource_group_arn = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.capacity_reservation_specification == null || contains(["open", "none"], var.capacity_reservation_specification.capacity_reservation_preference)
    error_message = "Capacity reservation preference must be either 'open' or 'none'."
  }
}

# Tagging
variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "instance_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "root_block_device_tags" {
  description = "Additional tags for the root block device"
  type        = map(string)
  default     = {}
}

variable "ebs_block_device_tags" {
  description = "Additional tags for EBS block devices"
  type        = map(string)
  default     = {}
}
