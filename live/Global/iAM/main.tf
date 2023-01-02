resource "aws_iam_user" "newuser" {
    count = length(var.user_name)
    name  = var.user_name[count.index]   # Use user names in the list defined in variables.tf
}