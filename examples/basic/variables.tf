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

variable "operating_system" {
  description = "Operating system for the EC2 instance"
  type        = string
  default     = "amazon-linux-2"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = null
}
