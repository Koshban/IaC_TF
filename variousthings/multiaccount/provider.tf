# Explicitly setting up providers plugins path
terraform {
  required_providers {
    aws = {
        source = "registry.terraform.io/hashicorp/aws"
        version = "~> 4.0"
    }
  }
}
# Provider, both using different accounts/IDs
provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
    alias           = "parent"
}

provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
    alias           = "child"

    assume_role {
      # role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>"
      role_arn = "arn:aws:iam::521063589659:role/OrganizationAccountAccessRole"
    }
}

# data "aws_caller_identity" "parent" {
#     provider = aws.parent
# }

# data "aws_caller_identity" "child" {
#     provider = aws.child
# }