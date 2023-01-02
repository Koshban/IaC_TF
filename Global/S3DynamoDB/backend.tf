# Backend to link storing TF State in S3 and DynamoDB
terraform {
  backend "s3" {
    # bucket = "kaushikb-terraform-s3-state"  # Your S3 bucket name
    key     = "global/s3/terraform.tfstate"  # The filepath within the S3 bucket where the Terraform state file should be written
    encrypt = true
    profile = "credentials"
  }
}