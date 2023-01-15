## Create the ALB
resource "aws_lb" "kaushikb_lb" {
    name                = var.alb_name # "terraform-asg-kaushikb"
    load_balancer_type  = "application"
    subnets             = var.subnet_ids
    security_groups     = [aws_security_group.kaushikb_lb_sg_instance.id]
  
}

## Create the ALB Listener

resource "aws_lb_listener" "http" {
    load_balancer_arn   = aws_lb.kaushikb_lb.arn
    port                = local.http_port
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
    name =  var.alb_name  # "KaushikTerraFormExample_alb_instance"
}

# In Modules use External rules rather than Inline Blocks as these make it easier to add more rules from outside the modules
resource "aws_security_group_rule" "http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.kaushikb_lb_sg_instance.id 
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips # CIDR = IP address Range, 0.0.0.0/0 allowed incoming on 8080 from any IP
}
resource "aws_security_group_rule" "http_outbound" {
    type = "egress"
    security_group_id = aws_security_group.kaushikb_lb_sg_instance.id 
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips 
}

# resource "aws_lb_target_group" "asg_lb_target" {
#     name = "terraform-asg-kaushikb"
#     port = var.server_port
#     protocol = "HTTP"
#     vpc_id = data.aws_vpc.default.id

#     health_check {
#       path                  = "/"
#       protocol              = "HTTP"
#       matcher               = "200"  # Healthy when response back from an instance is 200 OK
#       interval              = 15
#       timeout               = 3
#       healthy_threshold     = 2
#       unhealthy_threshold   = 2
#     }  
# }

# resource "aws_lb_listener_rule" "asg_lb_target" {
#     listener_arn    = aws_lb_listener.http.arn
#     priority        = 100

#     condition {
#       path_pattern {
#         values = ["*"]
#       }
#     }

#     action {
#       type = "forward"
#       target_group_arn = aws_lb_target_group.asg_lb_target.arn
#     }  
# }

# Local state

locals {
    http_port       = 80
    any_port        = 0
    any_protocol    = "-1"
    tcp_protocol    = "tcp"
    all_ips         = ["0.0.0.0/0"]
}