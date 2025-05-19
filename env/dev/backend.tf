terraform {
  backend "s3" {
    bucket = "terra-task-dev-state"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
