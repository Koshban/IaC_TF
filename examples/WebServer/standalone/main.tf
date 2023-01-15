module "hello_world_app" {
  source = "../../../modules/services/WebServer"

  server_text = var.server_text
  environment = var.environment

  mysql_config = var.mysql_config  # To use in Testing

  # db_remote_state_bucket = "kaushikb-terraform-s3-state"
  # db_remote_state_key    = "examples/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
  ami                = data.aws_ami.ubuntu.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}