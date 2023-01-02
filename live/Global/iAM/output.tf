output "first_arn" {
    value       = aws_iam_user.newuser[0].arn 
    description = "The ARN for the first user"
}

output "all_arn" {
    value       = aws_iam_user.newuser[*].arn 
    description = "The ARN for the users"
}
# The concat function takes two or more lists as inputs and combines them into a single list. 
# The one function takes a list as input and if the list has 0 elements, it returns null; if the list has 1 element, it returns that element; 
# and if the list has more than 1 element, it shows an error. Putting them together we can find which access returned values and then print it
output "neo_cloudwatch_policy_arn" {
    value = concat(one(aws_iam_user_policy_attachment.neo_cloudwatch_full_access[*].policy_arn,
                       aws_iam_user_policy_attachment.neo_cloudwatch_read_only[*].policy_arn))  
}