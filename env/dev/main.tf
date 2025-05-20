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
  # aws_region  = var.aws_region
  # aws_access_key = var.aws_access_key
  # aws_secret_key = var.aws_secret_key
}

module "compute" {
  source         = "../../compute/ec2"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  subnet_ids     = module.network.public_subnet_ids
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  user_data_file = "${path.module}/setup.sh"
  # aws_region     = var.aws_region
  # aws_access_key = var.aws_access_key
  # aws_secret_key = var.aws_secret_key
}
