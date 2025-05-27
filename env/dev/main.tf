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

resource "null_resource" "wait_for_ssh" {
  depends_on = [module.compute]
  provisioner "local-exec" {
    command = <<EOT
      for i in {1..30}; do
        nc -zv ${module.compute.instance_public_ip} 22 && exit 0
        sleep 5
      done
      echo "Timeout waiting for SSH" >&2
      exit 1
    EOT
  }
}

resource "null_resource" "ansible_provision" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_HOST_KEY_CHECKING=False
      export env=${var.environment}
      export public_ip=${module.compute.instance_public_ip}
      export private_key="${path.root}/../../compute/ec2/${var.environment}_test_key.pem"
      envsubst < ${path.module}/playbook/inventory.tpl > ${path.module}/playbook/inventory.ini
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/playbook/nginx.yml --extra-vars "env=${var.environment}"
    EOT
  }
}