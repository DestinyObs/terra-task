output "webapp_instance_public_ip" {
  value = module.compute.instance_public_ip
}

output "private_key_path" {
  value = "${path.root}/../../compute/ec2/${var.environment}_test_key.pem"
}