terraform {
  required_version = "1.3.6"
  required_providers {
    aws = {
        source = "registry.terraform.io/hashicorp/aws"
        version = "~> 4.0"
    }
  }
}
provider "aws" {
    region      = "ap-southeast-1"
    profile     = "default"
}
