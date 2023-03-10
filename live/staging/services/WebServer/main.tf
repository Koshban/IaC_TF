backend "s3" {
  }
module "WebServer" {
    source                  = "../../../../modules/services/WebServer"
    # source                  = "github.com/Koshban/IaC_TF/tree/v0.0.1/modules/services/WebServer"
    cluster_name            = "webserver-staging"
    server_text             = var.server_text
    environment             = var.environment
    db_remote_state_bucket  = var.db_remote_state_bucket
    db_remote_state_key     = var.db_remote_state_key

    instance_type       = "t2.micro"  # micro for Staging, Macro for Prod
    min_size            = 2
    max_size            = 2
    enable_autoscaling  = false
    ami                = data.aws_ami.ubuntu.id
}
# Separate resource to allow inbound port on a diff port in Staging than in Production
# This works because we defined the ingress and egress rules in the aws_security_block as external rather than as inline groups
resource "aws_security_group_rule" "allow_inbound_staging_env" {
    type = "ingress"
    source_security_group_id = module.WebServer.alb_security_group_id
    from_port   = 12345
    to_port     = 12345
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}