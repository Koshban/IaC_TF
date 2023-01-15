bucket          = "kaushikb-terraform-s3-state"
key             = "prod/data-stores/mysql/terraform.tfstate"
region          = "ap-southeast-1"
dynamodb_table  = "kaushikb-terraform-s3-state"
encrypt         = true
profile         = "default"  # To pickup profile named default in your home/.aws/credentials file
