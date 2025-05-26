# module "network" {
#   source     = "../../network/vpc"
#   environment = var.environment
#   cidr_block = "10.0.0.0/16"
# }

# module "compute" {
#   source       = "../../compute/ec2"
#   environment  = var.environment
#   vpc_id       = module.network.vpc_id
#   subnet_ids   = module.network.public_subnet_ids
#   ami_id       = "ami-0c7217cdde317cfec" 
#   instance_type = "t2.micro"
# }



module "network" {
  source      = "../../network/vpc"
  environment = var.environment
  cidr_block  = "10.0.0.0/16"
}

module "compute" {
  source         = "../../compute/ec2"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  subnet_ids     = module.network.public_subnet_ids
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  # user_data_file = "${path.module}/setup.sh"
}

# Defines a "null_resource" in Terraform.
# This is often used to perform provisioning steps that don't require direct resource creation.
resource "null_resource" "wait_for_ssh" {

  # Ensures this resource only executes after the "module.compute" resource has been created.
  depends_on = [module.compute]

  # Uses a local-exec provisioner to run a shell command on the local machine.
  provisioner "local-exec" {
    command = <<EOT
      # Loops up to 10 times, checking if port 22 (SSH) on the instance is open.
      for i in {1..10}; do
        # Uses netcat (nc) to test connectivity to the instance's public IP on port 22.
        # If SSH is available, exits successfully (exit 0) and stops further execution.
        nc -zv ${module.compute.instance_public_ip} 22 && exit 0
        
        # If SSH is not available, waits for 5 seconds before retrying.
        sleep 5
      done

      # If SSH does not become available after 10 attempts, prints an error message.
      echo "Timeout waiting for SSH" >&2
      
      # Exits with a non-zero status code to indicate failure.
      exit 1
    EOT
  }
}


resource "null_resource" "ansible_provision" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_HOST_KEY_CHECKING=False
      env=${var.environment} \
      public_ip=${module.compute.instance_public_ip} \
      private_key="${path.root}/../../compute/ec2/${var.environment}_test_key.pem" \
      envsubst < ${path.root}/../../inventory.tpl > ${path.root}/../../inventory.ini
      ansible-playbook -i ${path.root}/../../inventory.ini ${path.root}/../../nginx.yml --extra-vars "env=${var.environment}"
    EOT
  }
}