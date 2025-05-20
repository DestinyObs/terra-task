variable "aws_region" {
  description = "AWS region for prod"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key for prod"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for prod"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
}


variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
