# Basic Web Server Example

This example demonstrates how to create an EC2 instance configured as a simple web server with Apache HTTP Server.

## What This Creates

- EC2 instance with Apache web server pre-installed
- Security group allowing HTTP (80), HTTPS (443), and SSH (22) access
- Public IP address for web access
- Simple HTML welcome page with instance information
- Uses t3.micro instance type (AWS Free Tier eligible)

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# Optional: Include SSH key for server access
terraform apply -var="key_name=my-ec2-key"
```

## Configuration

Key parameters:
- `instance_type`: EC2 instance type (default: t3.micro)
- `aws_region`: AWS region (default: us-west-2)
- `key_name`: Optional SSH key pair name for server access

## What Gets Installed

The user data script automatically:
1. Updates the system packages
2. Installs Apache HTTP Server (httpd)
3. Starts and enables the Apache service
4. Creates a custom welcome page with instance information

## Security Group

This example creates a security group that allows:
- **HTTP (port 80)**: Web traffic from anywhere
- **HTTPS (port 443)**: Secure web traffic from anywhere
- **SSH (port 22)**: Optional administrative access
- **Outbound**: All traffic

## Accessing Your Web Server

After deployment:

1. **Web Access**: Open the URL from the `web_url` output in your browser
2. **SSH Access**: Use the command from `ssh_connection_command` output (if key pair provided)

The web server will display a welcome page with:
- Server status confirmation
- Instance ID, availability zone, and instance type
- Custom styling and information

## Outputs

- `instance_id`: The ID of the created EC2 instance
- `public_ip`: Public IP address of the web server
- `private_ip`: Private IP address
- `web_url`: Direct URL to access the web server
- `ssh_connection_command`: SSH command (if key pair provided)
- `security_group_id`: ID of the web server security group
- `instance_state`: Current state of the instance

## Customization

To customize the web server:

1. **Modify the HTML**: Edit the HTML content in the `user_data` script
2. **Add SSL**: Configure HTTPS with SSL certificates
3. **Install additional software**: Add more packages to the user data script
4. **Custom applications**: Deploy your own web applications

## Cost

This example uses t3.micro which is eligible for AWS Free Tier (750 hours per month for the first 12 months).

## Troubleshooting

If the web server doesn't respond:
1. Check that the instance is running: `terraform output instance_state`
2. Verify security group allows HTTP traffic
3. SSH into the instance and check Apache status: `sudo systemctl status httpd`
4. Check Apache logs: `sudo tail -f /var/log/httpd/error_log`

## Cleanup

```bash
terraform destroy
```
