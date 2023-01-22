# Explicitly setting up providers plugins path
terraform {
  required_version = "1.3.6"
  required_providers {
    aws = {
        source = "registry.terraform.io/hashicorp/aws"
        version = "~> 4.0"
    }
  }
}
# Provider
provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
    alias           = "r1-sng"
}

provider "aws" {
    region          = "ap-northeast-1"
    profile         = "default"
    alias           = "r2-tky"
}

# Use in data and output to chekc its working

data "aws_region" "region1" {
    provider = aws.r1-sng
}

data "aws_region" "region2" {
    provider = aws.r2-tky
}

# Find Ubuntu Canonical AMI for each region
data "aws_ami" "ubuntu_region_1" {
  provider = aws.r1-sng

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_region_2" {
  provider = aws.r2-tky

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }  
}
# Output

output "region1" {
    value = data.aws_region.region1.endpoint
    description = "First Region"  
}

output "region2" {
    value = data.aws_region.region2
    description = "2nd Region"  
}

# Deploy EC2 in 2 different Regions

resource "aws_instance" "region1_instance" {
    provider = aws.r1-sng
    ami             = data.aws_ami.ubuntu_region_1.id  # Canonical, Ubuntu, 22.04 LTS in Singapore AWS,  amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro"   
}

resource "aws_instance" "region2_instance" {
    provider = aws.r2-tky
    ami             = data.aws_ami.ubuntu_region_2.id  # Canonical, Ubuntu, 22.04 LTS in Tokyo AWS , amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro"   
}

output "instance_region_1_az" {
  value       = aws_instance.region1_instance.availability_zone
  description = "The AZ where the instance in the first region deployed"
}

output "instance_region_2_az" {
  value       = aws_instance.region2_instance.availability_zone
  description = "The AZ where the instance in the second region deployed"
}