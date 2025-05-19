module "network" {
  source     = "../../network/vpc"
  environment = var.environment
  cidr_block = "10.1.0.0/16"
}

module "compute" {
  source       = "../../compute/ec2"
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.public_subnet_ids
  ami_id       = "ami-0c7217cdde317cfec" # example AMI
  instance_type = "t3.micro"
}
