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
