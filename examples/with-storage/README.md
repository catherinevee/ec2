# EC2 Instance with Custom Storage Example

This example demonstrates how to create an EC2 instance with custom EBS storage configuration, including multiple volumes with different performance characteristics.

## What This Creates

- EC2 instance with custom root volume configuration
- Additional data volume for application data
- Optional log volume for application logs
- Automated volume formatting and mounting via user data
- EBS optimization enabled for better storage performance

## Storage Configuration

### Root Volume
- **Default**: 20GB gp3 with 3000 IOPS and 125 MB/s throughput
- **Encrypted**: Yes
- **Mount Point**: `/` (system root)

### Data Volume
- **Default**: 50GB gp3 with 3000 IOPS and 125 MB/s throughput
- **Device**: `/dev/sdf` (appears as `/dev/xvdf` in instance)
- **Mount Point**: `/data`
- **Encrypted**: Yes

### Log Volume (Optional)
- **Default**: 20GB gp3 with 3000 IOPS and 125 MB/s throughput
- **Device**: `/dev/sdg` (appears as `/dev/xvdg` in instance)
- **Mount Point**: `/logs`
- **Encrypted**: Yes

## Usage

### Basic Configuration
```bash
terraform init
terraform plan
terraform apply
```

### Custom Storage Configuration
```bash
# Custom root and data volume sizes
terraform apply \
  -var="root_volume_size=30" \
  -var="data_volume_size=100" \
  -var="create_log_volume=true"
```

### High-Performance Configuration
```bash
# High IOPS configuration for demanding workloads
terraform apply \
  -var="root_volume_type=io2" \
  -var="root_volume_iops=10000" \
  -var="data_volume_type=io2" \
  -var="data_volume_iops=20000"
```

### Configuration File
Create `terraform.tfvars`:
```hcl
# Instance configuration
instance_type = "m5.large"
key_name      = "my-ec2-key"

# Root volume
root_volume_type       = "gp3"
root_volume_size       = 30
root_volume_iops       = 4000
root_volume_throughput = 250

# Data volume
data_volume_type       = "gp3"
data_volume_size       = 100
data_volume_iops       = 5000
data_volume_throughput = 250

# Log volume
create_log_volume = true
log_volume_size   = 50

# Storage options
ebs_optimized                   = true
delete_volumes_on_termination   = false
```

## Volume Types

### GP3 (General Purpose SSD) - Recommended
- **Use Case**: Most workloads
- **Performance**: 3,000-16,000 IOPS, 125-1,000 MB/s throughput
- **Cost**: Most cost-effective for general use

### GP2 (General Purpose SSD) - Legacy
- **Use Case**: Basic workloads
- **Performance**: 3 IOPS per GB (burst to 3,000)
- **Cost**: Slightly higher than GP3

### IO1/IO2 (Provisioned IOPS SSD)
- **Use Case**: High-performance databases
- **Performance**: Up to 64,000 IOPS (IO2: up to 256,000)
- **Cost**: Higher cost, pay for provisioned IOPS

## Automatic Setup

The user data script automatically:
1. **Formats** new volumes with ext4 filesystem
2. **Mounts** volumes to appropriate mount points
3. **Configures** persistent mounting via `/etc/fstab`
4. **Sets** proper permissions for ec2-user
5. **Creates** status file with storage information

## Mount Points

After deployment, you'll have:
- `/` - Root filesystem (OS and applications)
- `/data` - Data volume (application data, databases)
- `/logs` - Log volume (application logs, if enabled)

## Verification

SSH into the instance and run:
```bash
# Check all block devices
lsblk

# Check mounted filesystems
df -h

# Check storage status
cat /home/ec2-user/storage_status.txt

# Verify data directory
ls -la /data

# Verify logs directory (if created)
ls -la /logs
```

## Use Cases

### Database Server
```hcl
data_volume_type = "io2"
data_volume_size = 500
data_volume_iops = 10000
create_log_volume = true
```

### Web Application
```hcl
root_volume_size = 30
data_volume_size = 100
create_log_volume = true
log_volume_size = 50
```

### Development Environment
```hcl
root_volume_size = 20
data_volume_size = 50
create_log_volume = false
```

## Performance Considerations

### EBS Optimization
- **Enabled by default** for better network performance
- **Required** for io1/io2 volumes
- **Recommended** for gp3 volumes with high throughput

### Instance Types
- **t3.micro**: Up to 2,085 Mbps EBS bandwidth
- **m5.large**: Up to 4,750 Mbps EBS bandwidth
- **m5.xlarge**: Up to 4,750 Mbps EBS bandwidth

## Cost Optimization

1. **Use GP3**: More cost-effective than GP2
2. **Right-size volumes**: Don't over-provision
3. **Delete on termination**: Set to true for temporary instances
4. **Monitor usage**: Use CloudWatch metrics

## Security Features

- **Encryption at rest**: All volumes encrypted by default
- **Encryption in transit**: Between instance and EBS
- **KMS integration**: Uses default AWS managed keys
- **IAM permissions**: Proper access controls

## Outputs

The example provides comprehensive outputs including:
- Instance and volume IDs
- Storage configuration summary
- SSH connection command
- Useful storage verification commands

## Cleanup

```bash
terraform destroy
```

**Note**: If `delete_volumes_on_termination = false`, you may need to manually delete volumes after destroying the instance.

## Troubleshooting

### Volume Not Mounting
1. Check if device exists: `ls -la /dev/xvdf`
2. Check user data logs: `cat /var/log/user-data.log`
3. Manually mount: `sudo mount /dev/xvdf /data`

### Performance Issues
1. Verify EBS optimization: Check instance type compatibility
2. Monitor IOPS usage: Use CloudWatch EBS metrics
3. Check network bandwidth: Instance type limits

### Storage Full
1. Check disk usage: `df -h`
2. Find large files: `du -sh /*`
3. Clean up logs: `sudo journalctl --vacuum-time=7d`
