# Minimal EC2 Instance Example

This example demonstrates the absolute minimal configuration required to create an EC2 instance using the module.

## What This Creates

- A single EC2 instance with default settings
- Uses t3.micro instance type (AWS Free Tier eligible)
- Uses default VPC and security group
- Uses Amazon Linux 2 AMI (module default)
- No SSH key pair (instance will not be accessible via SSH)

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Configuration

This example uses only the required parameter:
- `instance_type`: Set to "t3.micro" for cost efficiency

All other parameters use the module's default values:
- Operating system: Amazon Linux 2
- VPC: Default VPC
- Security group: Default security group
- No SSH key pair
- No additional storage
- Basic monitoring enabled

## Outputs

- `instance_id`: The ID of the created EC2 instance
- `public_ip`: Public IP address (if assigned)
- `private_ip`: Private IP address
- `instance_state`: Current state of the instance

## Cost

This example uses t3.micro which is eligible for AWS Free Tier (750 hours per month for the first 12 months).

## Security Note

This instance will not be accessible via SSH since no key pair is specified. This is suitable for instances that don't require direct access or use other connection methods.
