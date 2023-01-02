variable "user_name" {
    description = "Create IAM users with these names"
    type        = list(string)
    default     = ["neo", "trinity", "morpheus", "oracle"]  
}

variable "give_neo_cloudwatch_full_access" {
    description = "If true, neo gets full access to CloudWatch"
    type        = bool
    default     = false  
}