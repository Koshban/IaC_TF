# Provider
provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
    # To reliable add Tags to all your AWS resources, sourcing through the Modules
    default_tags {
        Owner       = "KaushikB"
        ManagedBy   = "TF"
    }
}