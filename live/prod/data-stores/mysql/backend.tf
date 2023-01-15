# Backend to link storing TF State in S3 and DynamoDB
terraform {
  backend "s3" {
    key = "prod/data-stores/mysql/terraform.tfstate"     
  }
}