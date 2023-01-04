# Backend to link storing TF State in S3 and DynamoDB
terraform {
  backend "s3" {
    key = "staging/data-stores/mysql/terraform.tfstate" 
    encrypt = true
  }
}