terraform {
  backend "s3" {
    bucket = "terra-task-prod-state"
    key    = "env/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
