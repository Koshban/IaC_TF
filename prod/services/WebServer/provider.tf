# Provider
provider "aws" {
    region      = "ap-southeast-1"
    access_key      = "AKIAWC5B2DHPPL5PKB2I"
    secret_key      = "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"
}
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}