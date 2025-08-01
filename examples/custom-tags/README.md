# EC2 Instance with Custom Tags Example

This example demonstrates comprehensive tagging strategies for EC2 instances, including cost allocation, compliance, operational, and business tags.

## What This Creates

- EC2 instance with extensive tagging for enterprise environments
- Default tags applied at the provider level
- Resource-specific tags for detailed categorization
- Cost allocation tags for billing and chargeback
- Operational tags for automation and monitoring

## Tagging Strategy

This example implements a comprehensive tagging strategy with the following categories:

### Identity and Ownership
- `Name`: Resource identifier
- `Owner`: Resource owner
- `Team`: Responsible team
- `Contact`: Contact email

### Environment and Lifecycle
- `Environment`: dev/staging/prod
- `Lifecycle`: Resource lifecycle stage
- `Project`: Project name
- `ManagedBy`: Management tool (Terraform)

### Cost Management
- `CostCenter`: Cost center for billing
- `Department`: Owning department
- `BillingProject`: Project for billing purposes

### Technical Details
- `Application`: Application name
- `Service`: Service name
- `Component`: Component within service
- `Version`: Application version

### Operational
- `BackupRequired`: Backup requirements
- `MonitoringLevel`: Monitoring requirements
- `MaintenanceWindow`: Maintenance schedule
- `AutoStart`/`AutoStop`: Automation schedules

### Compliance and Security
- `DataClassification`: Data sensitivity level
- `ComplianceScope`: Compliance requirements
- `SecurityLevel`: Security requirements

### Business Context
- `BusinessUnit`: Business unit
- `Purpose`: Resource purpose
- `Criticality`: Business criticality

## Usage

### Basic Usage
```bash
terraform init
terraform plan
terraform apply
```

### Custom Configuration
Create a `terraform.tfvars` file:
```hcl
# Project Information
project_name = "ecommerce-platform"
environment  = "prod"

# Ownership
owner         = "John Doe"
team          = "Platform Engineering"
contact_email = "platform@company.com"

# Cost Management
cost_center     = "TECH-001"
department      = "Engineering"
billing_project = "ecommerce-infrastructure"

# Application Details
application_name    = "product-catalog"
service_name        = "catalog-api"
component          = "web-server"
application_version = "2.1.0"

# Operational
backup_required     = "true"
monitoring_level    = "enhanced"
maintenance_window  = "Sunday 01:00-03:00 UTC"

# Compliance
data_classification = "confidential"
compliance_scope    = "PCI-DSS"
security_level      = "high"

# Business
business_unit = "E-commerce"
purpose       = "Production API server"
criticality   = "high"
```

## Default Tags

The provider configuration includes default tags applied to all resources:
- `Project`: From variable
- `Environment`: From variable
- `ManagedBy`: "Terraform"
- `CreatedBy`: From variable
- `CreatedOn`: Current date

## Benefits of This Tagging Strategy

### Cost Management
- **Chargeback**: Allocate costs to specific departments/projects
- **Budget Tracking**: Monitor spending by environment, application, or team
- **Cost Optimization**: Identify underutilized resources

### Operational Excellence
- **Automation**: Auto-start/stop based on tags
- **Monitoring**: Apply monitoring rules based on criticality
- **Maintenance**: Schedule maintenance windows

### Compliance and Governance
- **Data Classification**: Ensure proper handling of sensitive data
- **Compliance Tracking**: Meet regulatory requirements
- **Security Policies**: Apply security controls based on classification

### Resource Management
- **Inventory**: Comprehensive resource catalog
- **Ownership**: Clear responsibility assignment
- **Lifecycle**: Track resource lifecycle stages

## Outputs

- `instance_id`: EC2 instance ID
- `public_ip`: Public IP address
- `private_ip`: Private IP address
- `instance_tags`: All applied tags
- `ssh_connection_command`: SSH command (if key provided)
- `cost_allocation_tags`: Key tags for cost reports

## Best Practices

1. **Consistency**: Use standardized tag keys across all resources
2. **Automation**: Enforce tagging through policies
3. **Validation**: Use variable validation for critical tags
4. **Documentation**: Document your tagging strategy
5. **Governance**: Regular tag compliance audits

## Cost

This example uses t3.micro which is eligible for AWS Free Tier. The comprehensive tagging enables better cost tracking and optimization.

## Cleanup

```bash
terraform destroy
```

## Integration with AWS Services

These tags integrate with:
- **AWS Cost Explorer**: Cost analysis and reporting
- **AWS Config**: Compliance monitoring
- **AWS Systems Manager**: Automation and patching
- **AWS CloudWatch**: Monitoring and alerting
- **AWS Resource Groups**: Resource organization
