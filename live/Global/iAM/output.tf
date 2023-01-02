output "first_arn" {
    value       = aws_iam_user.newuser[0].arn 
    description = "The ARN for the first user"
}

output "all_arn" {
    value       = aws_iam_user.newuser[*].arn 
    description = "The ARN for the users"
}