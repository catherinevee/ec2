# Development Guide

Guidance for developers working with the AWS EC2 module.

## Prerequisites

- Terraform >= 1.13.0
- AWS Provider ~> 6.2.0
- Terragrunt >= 0.84.0

## Local Development Setup

1. **Install Required Tools:**
   ```bash
   # Install pre-commit hooks
   pip install pre-commit
   pre-commit install

   # Install tflint
   brew install tflint

   # Install tfsec
   brew install tfsec

   # Install checkov
   pip install checkov
   ```

2. **Configure AWS Credentials:**
   ```bash
   aws configure
   ```

## Development Workflow

1. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes:**
   - Update module code
   - Add/update tests
   - Update documentation

3. **Run Local Checks:**
   ```bash
   # Format code
   terraform fmt -recursive

   # Initialize Terraform
   terraform init

   # Validate configuration
   terraform validate

   # Run pre-commit hooks
   pre-commit run --all-files
   ```

4. **Test Changes:**
   ```bash
   # Run Terraform tests
   terraform test

   # Run example configurations
   cd examples/basic
   terraform init
   terraform plan
   ```

## Security Best Practices

1. **Encryption:**
   - Always enable EBS encryption
   - Use KMS for key management
   - Enable IMDSv2

2. **Network Security:**
   - Use private subnets for non-public instances
   - Implement proper security groups
   - Enable VPC flow logs

3. **Compliance:**
   - Follow tagging standards
   - Implement required compliance controls
   - Enable detailed monitoring for regulated workloads

## Testing Strategy

1. **Unit Tests:**
   - Test variable validation
   - Verify resource configurations
   - Check output values

2. **Integration Tests:**
   - Test with different OS types
   - Verify encryption settings
   - Validate networking setup

3. **Compliance Tests:**
   - Run security scans (tfsec, checkov)
   - Verify IAM permissions
   - Check encryption settings

## Releasing

1. **Version Update:**
   - Update CHANGELOG.md
   - Update version in variables.tf
   - Update examples

2. **Documentation:**
   - Update README.md
   - Verify example documentation
   - Update variable descriptions

3. **Release Process:**
   - Create release branch
   - Run full test suite
   - Create GitHub release
   - Update release notes

## Monitoring and Maintenance

1. **Resource Monitoring:**
   - Set up CloudWatch alarms
   - Configure metric filters
   - Implement log aggregation

2. **Cost Management:**
   - Use instance scheduler for non-prod
   - Implement auto-scaling where appropriate
   - Monitor resource utilization

3. **Updates and Patches:**
   - Regular AMI updates
   - Security patch management
   - Dependency updates

## Troubleshooting

Common issues and solutions:

1. **Instance Launch Failures:**
   - Check subnet capacity
   - Verify security group rules
   - Validate IAM permissions

2. **Encryption Issues:**
   - Verify KMS key permissions
   - Check encryption settings
   - Validate service-linked roles

3. **Networking Problems:**
   - Check route tables
   - Verify security groups
   - Validate subnet configurations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run all tests
5. Submit a pull request

## Support

For issues and questions:
1. Check the documentation
2. Review common issues
3. Open a GitHub issue
