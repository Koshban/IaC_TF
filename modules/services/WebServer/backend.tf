# Backend to link storing TF State in S3 and DynamoDB
terraform {
  backend "s3" {
  # key = "staging/services/WebServer/terraform.tfstate" 
    key = var.db_remote_state_key # The filepath within the S3 bucket where the Terraform state file should be written
  }
}