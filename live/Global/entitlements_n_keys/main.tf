# New iAM Users
resource "aws_iam_user" "newuser" {
    count = length(var.user_name)
    name  = var.user_name[count.index]   # Use user names in the list defined in variables.tf
}
#CW RO
resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}
# CW Full Access
resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

# Conditional CW Full Access

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
    count = var.give_neo_cloudwatch_full_access ? 1 : 0
    user = aws_iam_user.newuser[0].name 
    policy_arn = aws_iam_policy.cloudwatch_full_access.arn   
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
    count = var.give_neo_cloudwatch_full_access ? 0 : 1
    user = aws_iam_user.newuser[0].name 
    policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}

# iAM Policy Document and Role to allow running TF from Jenkins CICD Server running on your EC2
## First, define an assume role policy that allows the EC2 service to assume an IAM role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    
    principals {
      type  = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## Next, use the aws_iam_role resource to create an IAM role and pass it the JSON from your aws_iam_policy_document to use
resource "aws_iam_role" "instance" {
  name_prefix = var.name 
  assume_role_policy = data.aws_iam_policy_document.assume_role.json   
}

## attach one or more IAM policies to the IAM role that specify what you can actually do with the role once you’ve assumed it. 
data "aws_iam_policy_document" "ec2_admin_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]   
    }
  }

## And you can attach this policy to your IAM role using the aws_iam_role_policy resource:
resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json   
}

## The final step is to allow your EC2 Instance to automatically assume that IAM role by creating an instance profile:
resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name  
}

## And then tell your EC2 Instance to use that instance profile via the iam_instance_profile parameter
resource "aws_instance" "example" {
  ami = module.WebServer.ami
  instance_type = "t2.micro"
  # Attach the instance profile
  iam_instance_profile = aws_iam_instance_profile.instance.name  
}