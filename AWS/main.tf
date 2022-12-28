# DEclare Variables to use as Input at various places or can be declared in .env or used in parameters while calling tf apply
variable "server_port" {
    description = "Port number for the HTTP requests"
    type        = number
    default     = 8080
}

variable "alb_sg_port" {
    description = "Port number for the HTTP requests"
    type        = number
    default     = 80
}

# Provider
provider "aws" {
    region      = "ap-southeast-1"
    # access_key  = ""
    # secret_key  = ""
}

# Plain EC2/Compute
## EC2 definition first
resource "aws_instance" "kaushikb" {
    ami             = "ami-02045ebddb047018b"  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro" 

    vpc_security_group_ids = [aws_security_group.kaushikb_instance.id]  # Use TF Expression to add reference another resource creating implicit dependency.
    #e.g. use the security group dependency here

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World, Here I come!!" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    user_data_replace_on_change = true  # With flag = true here, TF will first terminate the instance and launch a new one.
    # Else User data Script wont get executed, if used default of update originla in place
  
    tags = {
        Name = "KaushikTerraFormExample"  # EC2 Instance Name
    }
}
## Create a Security Group to override AWS EC2 default of no incoming/outgoin traffic
resource "aws_security_group" "kaushikb_instance" {
    name = "KaushikTerraFormExample_instance"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # CIDR = IP address Range, 0.0.0.0/0 allowed incoming on 8080 from any IP
    }
}

# Auto Scaling Group first the instance template and then the Group itself
## ASG Instance definition
resource "aws_launch_configuration" "kaushikbASG" {
    image_id        = "ami-02045ebddb047018b"  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-12-01
    instance_type   = "t2.micro" 
    security_groups = [aws_security_group.kaushikb_instance.id]  # Use TF Expression to add reference another resource creating implicit dependency.
    #e.g. use the security group dependency here

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World, Here I come!!" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    # Required when using a launch configuration with an auto scaling group. So that references can be repointed first to new
    # resource before deleting old ones
    lifecycle {
      create_before_destroy = true
    }
}

## ASG Group definition
resource "aws_autoscaling_group" "kaushikb_as_group" {
    launch_configuration    = aws_launch_configuration.kaushikbASG.name
    vpc_zone_identifier     = data.aws_subnets.default.ids  # get the Subnet IDs to use in ASG
  ### Target Group integration with ALB so that it knows which instance to send requests to
    target_group_arns       = [aws_lb_target_group.asg_lb_target.arn]
    health_check_type       = "ELB" #default is EC2. ELB health_check instructs ASG to use target groups's health check to determine if the instance is healthy
    # else automatically replace it 

    min_size                = 2
    max_size                = 10
    desired_capacity        = 4

    tag {
        key = "Name"
        value = "terraform-asg-kaushikb"
        propagate_at_launch = true
    }  
}

# Application Load Balancer to really utilise the Auto Scaling Groups
## Create the ALB
resource "aws_lb" "kaushikb_lb" {
    name                = "terraform-asg-kaushikb"
    load_balancer_type  = "application"
    subnets             = data.aws_subnets.default.ids
    security_groups     = [aws_security_group.kaushikb_lb_sg_instance.id]
  
}

## Create the ALB Listener

resource "aws_lb_listener" "http" {
    load_balancer_arn   = aws_lb.kaushikb_lb.arn
    port                = 80
    protocol            = "HTTP"
### BY default return a simple 404 page for requests that don’t match any listener rules.
default_action {
  type = "fixed-response"

  fixed_response {
    content_type = "text/plain"
    message_body = "404: page not found"
    status_code  = 404
        }
    }
}

## Create a Security Group to allowe incoming on port 80 and outgoing on all ports for the ALB
resource "aws_security_group" "kaushikb_lb_sg_instance" {
    name = "KaushikTerraFormExample_alb_instance"
    ### Allow inbound HTTP Requests on port 80
    ingress {
        from_port   = var.alb_sg_port
        to_port     = var.alb_sg_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # CIDR = IP address Range, 0.0.0.0/0 allowed incoming on 8080 from any IP
    }
    ### Allow outbound to all ports 
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_lb_target_group" "asg_lb_target" {
    name = "terraform-asg-kaushikb"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
      path                  = "/"
      protocol              = "HTTP"
      matcher               = "200"  # Healthy when response back from an instance is 200 OK
      interval              = 15
      timeout               = 3
      healthy_threshold     = 2
      unhealthy_threshold   = 2
    }  
}

resource "aws_lb_listener_rule" "asg_lb_target" {
    listener_arn    = aws_lb_listener.http.arn
    priority        = 100

    condition {
      path_pattern {
        values = ["*"]
      }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg_lb_target.arn
    }  
}
# Data sources to get data back from AWS before using it in your ASG e.g. data "<PROVIDER>_<TYPE>" "<NAME>" {   [CONFIG ...] }
## VPC
data "aws_vpc" "default" {
    default = true  # Lookup Default VPC
}

## Subnets
data "aws_subnets" "default" {
    filter {
      name      = "vpc-id"
      values    = [data.aws_vpc.default.id]
    }
}
# Output variables
output "public_ip" {
    value       = aws_instance.kaushikb.public_ip
    description = "Public IP4 IP of the instance created"
}

output "alb_dns_name" {
    value       = aws_lb.kaushikb_lb.dns_name
    description = "Domain Name/DNS of the Load Balancer"
}