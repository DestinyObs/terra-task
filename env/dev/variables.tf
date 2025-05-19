variable "aws_region" {
  description = "AWS region for dev"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key for dev"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for dev"
  type        = string
  sensitive   = true
}



variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}


