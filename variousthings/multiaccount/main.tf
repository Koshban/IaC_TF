module "multi_account_example" {
  source = "../../modules/multiaccount"

  providers = {
    aws.parent = aws.parent
    aws.child  = aws.child
  }
}