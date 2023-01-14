resource "aws_instance" "region1_instance" {
    provider        = aws
    ami             = data.aws_ami.ubuntu_region_1.id  # Canonical, Ubuntu, 22.04 LTS in Singapore AWS,  amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro"   
# Attach the instance profile
  iam_instance_profile = aws_iam_instance_profile.instance.name
}
# Create an IAM role
resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Attach the EC2 admin permissions to the IAM role
resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json
}

# Create an IAM policy that grants EC2 admin permissions
data "aws_iam_policy_document" "ec2_admin_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}
# Create an instance profile with the IAM role attached
resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}
# Find Ubuntu Canonical AMI for each region
data "aws_ami" "ubuntu_region_1" {
  provider      = aws
  most_recent   = true
  owners        = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Allow the IAM role to be assumed by EC2 instances
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}