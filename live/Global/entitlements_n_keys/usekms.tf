provider "aws" {
    region          = "ap-southeast-1"
    profile         = "default"
 }

# fetching the Users Info
 data "aws_caller_identity" "self" {}

 # Use the aws_caller_identity data source’s outputs inside an aws_iam_policy_document data source to 
 # create a key policy that gives the current user admin permissions over the CMK.
 data "aws_iam_policy_document" "cmk_admin_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.self.arn]
    }
  }
 }

# Create the CMK
resource "aws_kms_key" "cmk" {
    policy = data.aws_iam_policy_document.cmk_admin_policy.json   
}

# Create a Human friendly name for the key
resource "aws_kms_alias" "cmk" {
    name = "alias/kms-cmk-example"
    target_key_id = aws_kms_key.cmk.id 
}

# How to decrypt
# 1) Read the original plan text keys
data "aws_kms_secrets" "creds" {
    secret {
      name = "db"
      payload = file("${path.module}/dbcredentials.yml.encrypted")
    }
}

# 2) Parse the YAML
locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

# 3) Use where reqd

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-kb-dbinstance"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = var.db_name

  # Pass the secrets to the resource
  username = local.db_creds.username
  password = local.db_creds.password
}


# Assuming secrets already stored in Secrets Manager with name db-creds

# Read the data
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "db-creds"
}

# Convert json to local variable

locals {
    db_creds = jsoncode(
        data.aws_secretsmanager_secret_version.creds.secret_string 
    )
}

# Use in #3 Above