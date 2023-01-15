module "WebServer" {
    source                  = "../../../modules/services/WebServer"
    server_text             = var.server_text
    environment             = var.environment
    cluster_name            = "webserver-cluster"
    db_remote_state_bucket  = var.db_remote_state_bucket
    db_remote_state_key     = var.db_remote_state_key # "prod/data-stores/mysql/terraform.tfstate"  
    instance_type           = "t2.micro"  # micro for Staging, Macro for Prod
    min_size                = 2
    max_size                = 10
    enable_autoscaling      = true 
    ami                     = data.aws_ami.ubuntu.id
    # custom_tags     = {
    #     Owner       = "KaushikB"
    #     ManagedBy   = "TF"
    # }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}



    

  
