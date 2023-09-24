locals {
  common_tags = {
    Environment = var.environment
    Feature  = "ingautomation"
    Source = "terraform-iac"
  }
}

provider "aws" {
  region = "us-east-1"
}
