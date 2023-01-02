variable "user_name" {
    description = "Create IAM users with these names"
    type        = list(string)
    default     = ["neo", "trinity", "morpheus", "oracle"]  
}