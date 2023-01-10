# Explicitly setting up providers plugins path
terraform {
  required_version = "1.3.6"
  required_providers {
    aws = {
        source = "registry.terraform.io/hashicorp/aws"
        version = "~> 4.0"
        configuration_aliases = [aws.parent, aws.child]
    }
  }
}


data "aws_caller_identity" "parent" {
    provider = aws.parent
}

data "aws_caller_identity" "child" {
    provider = aws.child
}