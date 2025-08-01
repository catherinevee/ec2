# EC2 Instance with SSH Key Pair Example

This example demonstrates how to create an EC2 instance with SSH access enabled using a key pair.

## What This Creates

- EC2 instance with SSH access enabled
- Custom security group allowing SSH (port 22) access
- Public IP address for external connectivity
- Uses t3.micro instance type (AWS Free Tier eligible)

## Prerequisites

Before running this example, you need to:

1. **Create an AWS Key Pair** in the AWS Console:
   - Go to EC2 → Key Pairs → Create Key Pair
   - Choose a name (e.g., "my-ec2-key")
   - Download the .pem file and save it securely
   - Set proper permissions: `chmod 400 ~/.ssh/my-ec2-key.pem`

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment (specify your key pair name)
terraform plan -var="key_name=my-ec2-key"

# Apply the configuration
terraform apply -var="key_name=my-ec2-key"
```

Or create a `terraform.tfvars` file:
```hcl
key_name = "my-ec2-key"
```

## Configuration

Key parameters:
- `key_name`: **Required** - Name of your AWS key pair
- `instance_type`: EC2 instance type (default: t3.micro)
- `aws_region`: AWS region (default: us-west-2)

## Security Group

This example creates a security group that allows:
- **Inbound**: SSH (port 22) from anywhere (0.0.0.0/0)
- **Outbound**: All traffic

⚠️ **Security Warning**: The security group allows SSH from anywhere (0.0.0.0/0). In production, restrict this to your specific IP address or IP range.

## Connecting to Your Instance

After deployment, use the SSH connection command from the output:

```bash
ssh -i ~/.ssh/your-key-name.pem ec2-user@<public-ip>
```

The exact command will be provided in the Terraform output as `ssh_connection_command`.

## Outputs

- `instance_id`: The ID of the created EC2 instance
- `public_ip`: Public IP address for SSH access
- `private_ip`: Private IP address
- `ssh_connection_command`: Ready-to-use SSH command
- `security_group_id`: ID of the created security group
- `instance_state`: Current state of the instance

## Cost

This example uses t3.micro which is eligible for AWS Free Tier (750 hours per month for the first 12 months).

## Cleanup

```bash
terraform destroy -var="key_name=my-ec2-key"
```
