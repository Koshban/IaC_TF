module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "hello-world-${var.environment}"
  ami           = var.ami
  instance_type = var.instance_type

  user_data     = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = local.mysql_config.address
    db_port     = local.mysql_config.port
    server_text = var.server_text
  })

  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = var.enable_autoscaling

  subnet_ids        = local.subnet_ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  custom_tags = var.custom_tags
}

module "alb" {
  source = "../../networking/alb"

  alb_name   = "hello-world-${var.environment}"
  # subnet_ids = data.aws_subnets.default.ids
  subnet_ids = local.subnet_ids
}



# Plain EC2/Compute
## EC2 definition first
resource "aws_instance" "kaushikb" {
    ami             = "ami-02045ebddb047018b"  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro" 

    vpc_security_group_ids = [aws_security_group.kaushikb_instance.id]  # Use TF Expression to add reference another resource creating implicit dependency.
    #e.g. use the security group dependency here

    user_data = templatefile("${path.module}/user-data.sh", {
        server_port = var.server_port
        db_address  = data.terraform_remote_state.db.outputs.address
        db_port     = data.terraform_remote_state.db.outputs.port
    })

    user_data_replace_on_change = true  # With flag = true here, TF will first terminate the instance and launch a new one.
    # Else User data Script wont get executed, if used default of update originla in place
  
    tags = {
        Name = "KaushikTerraFormExample"  # EC2 Instance Name
    }
}

resource "aws_lb_target_group" "asg" {
  name     = "hello-world-${var.environment}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# Data sources to get data back from AWS before using it in your ASG e.g. data "<PROVIDER>_<TYPE>" "<NAME>" {   [CONFIG ...] }
# ## VPC
data "aws_vpc" "default" {
    default = true  # Lookup Default VPC
}

data "terraform_remote_state" "db" {
    backend = "s3"
    config = {
      bucket = var.db_remote_state_bucket
      key    =   var.db_remote_state_key # "staging/data-stores/mysql/terraform.tfstate"  # The filepath within the S3 bucket where the Terraform state file should be written
      region = "ap-southeast-1" 
     }
}