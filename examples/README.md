# EC2 Terraform Module Examples

This directory contains examples demonstrating different use cases and configurations for the EC2 Terraform module. Each example is self-contained and includes documentation.

## Available Examples

### Basic Examples

#### 1. [minimal/](./minimal/)
**Minimal EC2 instance configuration**
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
