# Private EC2 Instance Example

This example demonstrates how to create an EC2 instance in a private subnet without a public IP address, suitable for secure internal workloads.

## What This Creates

- EC2 instance without public IP address
- Private security group allowing only VPC-internal traffic
- Optional VPC endpoints for private AWS service connectivity
- Uses t3.micro instance type (AWS Free Tier eligible)

## Security Features

### Network Isolation
- **No Public IP**: Instance cannot be reached from the internet
- **VPC-Only Access**: Security group allows traffic only from within the VPC
- **Private Subnet**: Deployed in a subnet without internet gateway route

### Security Group Rules
- **Inbound**: SSH (22), HTTP (80), HTTPS (443) from VPC CIDR only
- **Outbound**: All traffic allowed (for updates and AWS services)

## Usage

### Basic Deployment
```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### With VPC Endpoints (Recommended for Production)
```bash
# Deploy with VPC endpoints for private AWS service access
terraform apply -var="create_vpc_endpoints=true"
```

### With SSH Key
```bash
# Include SSH key for access via bastion host
terraform apply -var="key_name=my-ec2-key"
```

## Configuration Options

- `instance_type`: EC2 instance type (default: t3.micro)
- `aws_region`: AWS region (default: us-west-2)
- `key_name`: SSH key pair name (optional)
- `create_vpc_endpoints`: Create VPC endpoints for private connectivity (default: false)

## Accessing the Private Instance

Since this instance has no public IP, you can access it through:

### 1. Bastion Host (Jump Box)
Deploy a bastion host in a public subnet and SSH through it:
```bash
# SSH to bastion host first
ssh -i ~/.ssh/key.pem ec2-user@<bastion-public-ip>

# Then SSH to private instance
ssh -i ~/.ssh/key.pem ec2-user@<private-instance-ip>
```

### 2. AWS Systems Manager Session Manager
```bash
# Connect via Session Manager (no SSH key required)
aws ssm start-session --target <instance-id>
```

### 3. VPN Connection
Set up a VPN connection to your VPC for direct access.

### 4. AWS Direct Connect
Use Direct Connect for dedicated network connection.

## VPC Endpoints

When `create_vpc_endpoints = true`, this example creates:

- **S3 VPC Endpoint**: For private S3 access
- **EC2 VPC Endpoint**: For private EC2 API access

Benefits:
- Private connectivity to AWS services
- No internet gateway required for AWS API calls
- Enhanced security and compliance
- Reduced data transfer costs

## Use Cases

### Development and Testing
- Secure development environments
- Internal testing servers
- Database servers

### Production Workloads
- Application servers behind load balancers
- Database and cache servers
- Internal microservices
- Batch processing instances

### Compliance Requirements
- PCI DSS compliance
- HIPAA workloads
- Financial services applications
- Government and defense systems

## Outputs

- `instance_id`: EC2 instance ID
- `private_ip`: Private IP address
- `public_ip`: Public IP (should be null)
- `security_group_id`: Security group ID
- `vpc_id`: VPC ID
- `subnet_id`: Subnet ID
- `connection_info`: Access methods and SSH command
- `instance_state`: Instance state

## Security Best Practices

1. **Least Privilege**: Security group allows only necessary ports
2. **Network Segmentation**: Instance isolated from internet
3. **VPC Endpoints**: Private connectivity to AWS services
4. **Monitoring**: CloudWatch monitoring enabled
5. **Access Control**: Use IAM roles and Session Manager

## Limitations

- No direct internet access (use NAT Gateway if needed)
- Cannot receive inbound internet traffic
- Requires alternative access methods (bastion, VPN, Session Manager)
- Software updates may require NAT Gateway or VPC endpoints

## Cost Optimization

- Uses t3.micro (Free Tier eligible)
- VPC endpoints have hourly charges (only create if needed)
- No NAT Gateway costs (unless you add one separately)

## Cleanup

```bash
terraform destroy
```

## Next Steps

To enhance this setup:
1. Add NAT Gateway for outbound internet access
2. Implement bastion host for SSH access
3. Configure VPC Flow Logs for monitoring
4. Set up CloudWatch alarms for security monitoring
5. Implement AWS Config rules for compliance
