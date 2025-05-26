resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.environment}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  filename = "${path.module}/${var.environment}_test_key.pem"
  content  = tls_private_key.ec2_key.private_key_pem
  file_permission = "0600"
}
