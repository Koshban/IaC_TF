terraform {
  required_providers {
    aws = {
        source = "registry.terraform.io/hashicorp/aws"
        version = "~> 4.0"
    }
  }
}
# Provider
# provider "aws" {
#     region      = "ap-southeast-1"
#     profile     = "default"
# }