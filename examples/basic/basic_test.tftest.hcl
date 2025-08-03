run "verify_basic_deployment" {
  command = plan

  assert {
    condition     = length(aws_instance.this) > 0
    error_message = "No EC2 instance would be created"
  }

  assert {
    condition     = aws_instance.this.instance_type == "t3.micro"
    error_message = "Incorrect instance type"
  }
}

run "verify_encryption" {
  command = plan

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted == true
    error_message = "Root volume must be encrypted"
  }
}

run "verify_metadata_options" {
  command = plan

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 must be required"
  }
}
