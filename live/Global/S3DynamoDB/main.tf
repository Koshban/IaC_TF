# S3
## Bucket Creation
resource "aws_s3_bucket" "terraform_state" {
    bucket = "kaushikb-terraform-s3-state"
    # Mitigate accidental deletion
    lifecycle {
        prevent_destroy = false  # true when actually using it to store TF state files for team consumption      
    }  
}

## Bucket versioning for History
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {status = "Enabled"}  
}

## Encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

## Block all public Access, as an added safety ( by default public access is blocked but its to ensure access is not granted by mistake)
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket                  = aws_s3_bucket.terraform_state.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true   
}

# DynamoDB
## Dynamo DB for Locking the State files
resource "aws_dynamodb_table" "tflocks" {
    name = "kaushikb-terraform-s3-state"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"  # Primary Key called LockID, needs to be exact this spelling/Caps

    attribute {
      name = "LockID"
      type = "S"
    }
}



