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
  description = "Name of the AWS key pair for SSH access"
  type        = string
  
  validation {
    condition     = var.key_name != null && var.key_name != ""
    error_message = "Key name is required for SSH access. Create a key pair in AWS console first."
  }
}
