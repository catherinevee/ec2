# EC2 Terraform Module Examples

This directory contains various examples demonstrating different use cases and configurations for the EC2 Terraform module. Each example is self-contained and includes detailed documentation.

## Available Examples

### Basic Examples

#### 1. [minimal/](./minimal/)
**Absolute minimal EC2 instance configuration**
- Single t3.micro instance with default settings
- No SSH access, uses default VPC and security group
- Perfect for testing the module or learning Terraform
- AWS Free Tier eligible

#### 2. [basic/](./basic/)
**Standard basic configuration**
- EC2 instance with common settings
- Optional SSH key pair
- Uses default VPC with public IP
- Good starting point for most use cases

#### 3. [with-keypair/](./with-keypair/)
**EC2 instance with SSH access**
- Includes SSH key pair configuration
- Custom security group allowing SSH access
- Public IP for external connectivity
- Ready-to-use SSH connection command

#### 4. [web-server/](./web-server/)
**Basic web server setup**
- Apache HTTP server pre-installed
- Security group allowing HTTP/HTTPS traffic
- Custom welcome page with instance information
- User data script for automatic setup

#### 5. [custom-tags/](./custom-tags/)
**Comprehensive tagging strategy**
- Enterprise-level tagging for cost allocation
- Compliance and operational tags
- Default tags at provider level
- Best practices for resource management

#### 6. [private-instance/](./private-instance/)
**Private subnet deployment**
- No public IP address
- VPC-only security group rules
- Optional VPC endpoints for AWS services
- Secure internal workload configuration

#### 7. [with-storage/](./with-storage/)
**Custom EBS storage configuration**
- Multiple EBS volumes with different types
- Automated formatting and mounting
- Performance optimization options
- Storage best practices demonstration

### Advanced Examples

#### 8. [advanced/](./advanced/)
**Advanced EC2 configurations**
- Complex networking setups
- Advanced security configurations
- Performance optimizations

#### 9. [comprehensive/](./comprehensive/)
**Full-featured example**
- All module features demonstrated
- Production-ready configuration
- Maximum customizability

## Quick Start Guide

### 1. Choose Your Example
Select the example that best matches your use case:
- **Learning/Testing**: Start with `minimal/`
- **Development**: Use `with-keypair/` or `basic/`
- **Web Applications**: Try `web-server/`
- **Production**: Consider `custom-tags/` or `comprehensive/`
- **Secure Workloads**: Use `private-instance/`
- **Storage-Intensive**: Try `with-storage/`

### 2. Deploy an Example
```bash
# Navigate to your chosen example
cd examples/minimal/

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy the infrastructure
terraform apply
```

### 3. Clean Up
```bash
# Destroy the infrastructure when done
terraform destroy
```

## Common Configuration Patterns

### SSH Access
Most examples support optional SSH access:
```bash
terraform apply -var="key_name=my-ec2-key"
```

### Instance Types
Change instance type for different performance needs:
```bash
terraform apply -var="instance_type=t3.small"
```

### Regions
Deploy to different AWS regions:
```bash
terraform apply -var="aws_region=us-east-1"
```

## Example Comparison

| Example | SSH Access | Public IP | Custom Storage | Web Server | Tags | Complexity |
|---------|------------|-----------|----------------|------------|------|------------|
| minimal | ❌ | ✅ | ❌ | ❌ | Basic | ⭐ |
| basic | Optional | ✅ | ❌ | ❌ | Basic | ⭐ |
| with-keypair | ✅ | ✅ | ❌ | ❌ | Basic | ⭐⭐ |
| web-server | Optional | ✅ | ❌ | ✅ | Basic | ⭐⭐ |
| custom-tags | Optional | ✅ | ❌ | ❌ | Enterprise | ⭐⭐ |
| private-instance | Optional | ❌ | ❌ | ❌ | Basic | ⭐⭐⭐ |
| with-storage | Optional | ✅ | ✅ | ❌ | Basic | ⭐⭐⭐ |
| advanced | ✅ | ✅ | ✅ | Optional | Advanced | ⭐⭐⭐⭐ |
| comprehensive | ✅ | ✅ | ✅ | Optional | Enterprise | ⭐⭐⭐⭐⭐ |

## Prerequisites

Before using any example, ensure you have:

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **AWS key pair created** (for SSH-enabled examples)
4. **Appropriate IAM permissions** for EC2, VPC, and related services

## Cost Considerations

### Free Tier Eligible Examples
- `minimal/` - t3.micro instance
- `basic/` - t3.micro instance  
- `with-keypair/` - t3.micro instance
- `web-server/` - t3.micro instance
- `custom-tags/` - t3.micro instance

### Paid Resources
- `with-storage/` - Additional EBS volumes
- `private-instance/` - VPC endpoints (if enabled)
- `advanced/` - Larger instance types
- `comprehensive/` - Multiple resources

## Security Best Practices

1. **Use specific IP ranges** instead of 0.0.0.0/0 in production
2. **Enable encryption** for all EBS volumes
3. **Use IAM roles** instead of hardcoded credentials
4. **Implement least privilege** security group rules
5. **Enable CloudTrail** for audit logging
6. **Use private subnets** for sensitive workloads

## Troubleshooting

### Common Issues

#### Terraform Init Fails
```bash
# Clear cache and reinitialize
rm -rf .terraform
terraform init
```

#### Key Pair Not Found
```bash
# List available key pairs
aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName'
```

#### Instance Launch Fails
- Check AWS service limits
- Verify IAM permissions
- Ensure availability zone has capacity

#### SSH Connection Issues
- Verify security group allows SSH (port 22)
- Check key pair permissions: `chmod 400 ~/.ssh/key.pem`
- Ensure instance has public IP

### Getting Help

1. **Check example README**: Each example has detailed documentation
2. **Review Terraform logs**: Use `TF_LOG=DEBUG terraform apply`
3. **AWS Console**: Verify resources in AWS console
4. **Module Documentation**: Check main module README

## Contributing

When adding new examples:

1. **Create a new directory** under `examples/`
2. **Include all required files**:
   - `main.tf` - Terraform configuration
   - `variables.tf` - Input variables
   - `outputs.tf` - Output values
   - `README.md` - Documentation
3. **Follow naming conventions** and coding standards
4. **Test thoroughly** before submitting
5. **Update this README** with the new example

## Module Features Demonstrated

Each example demonstrates different aspects of the EC2 module:

- **Instance Configuration**: Types, AMIs, user data
- **Networking**: VPCs, subnets, security groups, public/private IPs
- **Storage**: Root volumes, additional EBS volumes, encryption
- **Security**: SSH keys, security groups, IAM roles
- **Monitoring**: CloudWatch, detailed monitoring
- **Tags**: Resource organization and cost allocation
- **Automation**: User data scripts, bootstrapping

Choose the examples that best demonstrate the features you need for your use case.
