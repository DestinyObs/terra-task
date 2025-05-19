terraform {
  backend "s3" {
    bucket = "terra-task-prod-state"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
