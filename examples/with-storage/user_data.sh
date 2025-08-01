#!/bin/bash
# User data script to format and mount additional EBS volumes

# Update system
yum update -y

# Install useful tools
yum install -y htop lsblk

# Wait for volumes to be attached
sleep 30

# Function to format and mount a volume
format_and_mount() {
    local device=$1
    local mount_point=$2
    local label=$3
    
    # Check if device exists
    if [ -b "$device" ]; then
        echo "Processing device: $device"
        
        # Check if device is already formatted
        if ! blkid "$device" > /dev/null 2>&1; then
            echo "Formatting $device with ext4..."
            mkfs.ext4 -L "$label" "$device"
        else
            echo "Device $device is already formatted"
        fi
        
        # Create mount point
        mkdir -p "$mount_point"
        
        # Mount the volume
        mount "$device" "$mount_point"
        
        # Add to fstab for persistent mounting
        echo "LABEL=$label $mount_point ext4 defaults,nofail 0 2" >> /etc/fstab
        
        # Set permissions
        chmod 755 "$mount_point"
        chown ec2-user:ec2-user "$mount_point"
        
        echo "Successfully mounted $device to $mount_point"
    else
        echo "Device $device not found"
    fi
}

# Format and mount data volume
format_and_mount "/dev/xvdf" "/data" "DataVolume"

# Format and mount log volume if it should be created
%{ if create_log_volume }
format_and_mount "/dev/xvdg" "/logs" "LogVolume"

# Create log directories
mkdir -p /logs/application
mkdir -p /logs/system
chown -R ec2-user:ec2-user /logs
%{ endif }

# Create status file
cat > /home/ec2-user/storage_status.txt << EOF
Storage Configuration Status
============================
Date: $(date)
Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)

Block Devices:
$(lsblk)

Mounted Filesystems:
$(df -h)

Fstab Entries:
$(grep -v '^#' /etc/fstab)
EOF

chown ec2-user:ec2-user /home/ec2-user/storage_status.txt

# Log completion
echo "Storage setup completed at $(date)" >> /var/log/user-data.log
