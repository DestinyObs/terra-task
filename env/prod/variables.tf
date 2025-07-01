variable "aws_region" {
  description = "AWS region for prod"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0e86e20dae9224db8"  # Ubuntu 24.04 LTS - us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
