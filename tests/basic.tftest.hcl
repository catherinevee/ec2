variables {
  instance_type = "t3.micro"
  subnet_id     = "subnet-12345678"
}

run "verify_instance_type" {
  command = plan

  assert {
    condition     = aws_instance.this.instance_type == var.instance_type
    error_message = "instance type did not match expected value"
  }
}

run "verify_encryption" {
  command = plan

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted == true
    error_message = "root volume encryption should be enabled by default"
  }
}

run "verify_imdsv2" {
  command = plan

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 should be required by default"
  }
}
