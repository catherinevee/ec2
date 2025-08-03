# Operating system configuration mapping
locals {
  os_config = {
    "amazon-linux-2" = {
      owners      = ["amazon"]
      name_filter = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    "amazon-linux-2023" = {
      owners      = ["amazon"]
      name_filter = ["al2023-ami-*-x86_64"]
    }
    "ubuntu-20.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    "ubuntu-22.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    "ubuntu-24.04" = {
      owners      = ["099720109477"] # Canonical
      name_filter = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
    }
    "rhel-8" = {
      owners      = ["309956199498"] # Red Hat
      name_filter = ["RHEL-8.*_HVM-*-x86_64-*-Hourly2-GP2"]
    }
    "rhel-9" = {
      owners      = ["309956199498"] # Red Hat
      name_filter = ["RHEL-9.*_HVM-*-x86_64-*-Hourly2-GP3"]
    }
    "centos-7" = {
      owners      = ["125523088429"] # CentOS
      name_filter = ["CentOS 7.*x86_64"]
    }
    "windows-2019" = {
      owners      = ["amazon"]
      name_filter = ["Windows_Server-2019-English-Full-Base-*"]
    }
    "windows-2022" = {
      owners      = ["amazon"]
      name_filter = ["Windows_Server-2022-English-Full-Base-*"]
    }
  }

  # Use OS-specific configuration if ami_id is null, otherwise use provided values
  ami_owners      = var.ami_id == null ? local.os_config[var.operating_system].owners : var.ami_owners
  ami_name_filter = var.ami_id == null ? local.os_config[var.operating_system].name_filter : var.ami_name_filter
}

# Data source for AMI
data "aws_ami" "this" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = local.ami_owners

  filter {
    name   = "name"
    values = local.ami_name_filter
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
