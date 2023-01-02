# Provider
provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
    default_tags {
        Owner       = "KaushikB"
        ManagedBy   = "TF"
    }
}
