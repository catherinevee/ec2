# Minimal EC2 Instance Example
# This example creates the most basic EC2 instance possible using the module

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
  region = "us-west-2"
}

# Create a minimal EC2 instance
module "minimal_ec2" {
  source = "../../"

  # Only required parameter
  instance_type = "t3.micro"

  # All other parameters will use module defaults
}
