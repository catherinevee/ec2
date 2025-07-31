# Comprehensive EC2 Example - Maximum Customizability

This example demonstrates the extensive customization capabilities of the enhanced EC2 Terraform module, showcasing all available parameters and security best practices.

## Features Demonstrated

### 🔒 **Security Best Practices**
- **IMDSv2 Enforcement**: Instance Metadata Service v2 required for enhanced security
- **Encryption at Rest**: All EBS volumes encrypted with customer-managed KMS keys
- **IAM Integration**: Dedicated IAM role and instance profile with least privilege
- **API Protection**: Termination and stop protection enabled
- **Enhanced Monitoring**: Detailed CloudWatch metrics enabled

### 🚀 **Performance Optimization**
- **EBS Optimization**: Enabled for better storage performance
- **CPU Configuration**: Customizable core count and hyperthreading settings
- **Credit Specification**: Configurable CPU credits for burstable instances
- **Storage Performance**: GP3 volumes with custom IOPS and throughput

### 🌐 **Advanced Networking**
- **IPv6 Support**: Configurable IPv6 address assignment
- **Private DNS**: Custom hostname configuration
- **Multiple IPs**: Support for secondary private IP addresses
- **Network Interface**: Advanced network interface configuration

### 🏗️ **Advanced Placement**
- **Placement Groups**: Support for cluster, partition, and spread placement
- **Dedicated Tenancy**: Support for dedicated hosts and instances
- **Availability Zone**: Explicit AZ placement control
- **Host Resource Groups**: Integration with host resource groups

### 💾 **Storage Flexibility**
- **Root Volume**: Customizable size, type, IOPS, and throughput
- **Additional Volumes**: Multiple EBS volumes with individual configuration
- **Encryption**: Per-volume encryption with custom KMS keys
- **Lifecycle Management**: Configurable deletion policies

### 🔧 **Advanced Features**
- **Hibernation**: Support for instance hibernation (compatible instance types)
- **Nitro Enclaves**: Confidential computing capabilities
- **Maintenance Options**: Auto-recovery configuration
- **User Data**: Flexible initialization scripts

## Usage

### Basic Usage

```hcl
module "ec2_comprehensive" {
  source = "../../"
  
  # Minimal required configuration
  instance_type = "t3.medium"
  
  # Enhanced security (recommended)
  metadata_options = {
    http_tokens = "required"  # IMDSv2 only
  }
  
  # Basic monitoring
  monitoring = true
}
```

### Production-Ready Configuration

```hcl
module "ec2_production" {
  source = "../../"
  
  # Core configuration
  instance_type    = "m5.large"
  operating_system = "amazon-linux-2023"
  key_name        = "my-key-pair"
  
  # Security configuration
  metadata_options = {
    http_tokens                = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags     = "enabled"
  }
  
  disable_api_termination = true
  iam_instance_profile   = aws_iam_instance_profile.app.name
  
  # Performance optimization
  monitoring    = true
  ebs_optimized = true
  
  cpu_options = {
    core_count       = 2
    threads_per_core = 1  # Disable hyperthreading
  }
  
  # Encrypted storage
  root_block_device = {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
    kms_key_id  = aws_kms_key.app.arn
  }
  
  # Additional data volume
  ebs_block_device = [{
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }]
  
  tags = {
    Environment = "production"
    Application = "web-server"
    Backup      = "required"
  }
}
```

### High-Performance Configuration

```hcl
module "ec2_high_performance" {
  source = "../../"
  
  # High-performance instance
  instance_type = "c5n.xlarge"
  
  # Placement for network performance
  placement_group = aws_placement_group.cluster.name
  
  # CPU optimization
  cpu_options = {
    core_count       = 4
    threads_per_core = 2
  }
  
  # High-performance storage
  root_block_device = {
    volume_type = "io2"
    volume_size = 100
    iops        = 10000
    encrypted   = true
  }
  
  # Enhanced networking
  ebs_optimized = true
  monitoring    = true
}
```

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `instance_type` | EC2 instance type | `string` | `"t3.medium"` | yes |
| `operating_system` | Operating system | `string` | `"amazon-linux-2"` | no |
| `key_name` | AWS key pair name | `string` | `null` | no |
| `disable_api_termination` | Enable termination protection | `bool` | `true` | no |
| `monitoring` | Enable detailed monitoring | `bool` | `true` | no |
| `root_volume_size` | Root volume size in GB | `number` | `20` | no |
| `hibernation` | Enable hibernation support | `bool` | `false` | no |

See [variables.tf](./variables.tf) for the complete list of configurable parameters.

## Outputs

This example provides comprehensive outputs including:

- **Instance Information**: ID, ARN, state, type, AMI
- **Network Details**: Public/private IPs, DNS names, security groups
- **Storage Information**: Block device configurations
- **Security Status**: Encryption, IAM, protection settings
- **Connection Commands**: SSH and Instance Connect commands
- **Cost Optimization**: Recommendations for cost savings
- **Security Recommendations**: Security posture assessment

## Security Considerations

### 🔐 **Encryption**
- All EBS volumes are encrypted by default
- Customer-managed KMS keys provide full control
- Encryption keys are automatically rotated

### 🛡️ **Access Control**
- IMDSv2 enforced to prevent SSRF attacks
- IAM instance profiles for secure API access
- Security groups restrict network access

### 🔒 **Protection**
- Termination protection prevents accidental deletion
- Stop protection available for critical instances
- Backup strategies through EBS snapshots

## Cost Optimization

### 💰 **Storage Costs**
- GP3 volumes offer better price/performance than GP2
- Right-size volumes to avoid over-provisioning
- Consider lifecycle policies for snapshots

### ⚡ **Compute Costs**
- Use Spot instances for fault-tolerant workloads
- Consider Reserved Instances for predictable workloads
- Enable hibernation for intermittent workloads

### 📊 **Monitoring Costs**
- Detailed monitoring incurs additional charges
- Use CloudWatch Logs for application monitoring
- Set up billing alerts for cost control

## Deployment

1. **Prerequisites**:
   ```bash
   # Ensure AWS CLI is configured
   aws configure
   
   # Verify Terraform installation
   terraform version
   ```

2. **Initialize and Plan**:
   ```bash
   terraform init
   terraform plan -var="key_name=my-key-pair"
   ```

3. **Deploy**:
   ```bash
   terraform apply -var="key_name=my-key-pair"
   ```

4. **Connect**:
   ```bash
   # Use the SSH command from outputs
   terraform output ssh_connection_command
   ```

## Troubleshooting

### Common Issues

1. **Instance Launch Failures**:
   - Check instance type availability in the selected AZ
   - Verify subnet has available IP addresses
   - Ensure security groups allow required traffic

2. **SSH Connection Issues**:
   - Verify key pair exists and is accessible
   - Check security group allows SSH (port 22)
   - Ensure instance has public IP if connecting from internet

3. **Storage Issues**:
   - Verify KMS key permissions for encryption
   - Check volume size limits for instance type
   - Ensure IOPS settings are within limits

### Support

For issues with this example:
1. Check the [main module documentation](../../README.md)
2. Review AWS EC2 documentation
3. Verify IAM permissions for all required actions

## License

This example is provided under the same license as the main EC2 module.
