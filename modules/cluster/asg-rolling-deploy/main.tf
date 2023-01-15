
# Auto Scaling Group first the instance template and then the Group 
## ASG Instance definition
resource "aws_launch_configuration" "kaushikbASG" {
    image_id        = var.ami  
    instance_type   = var.instance_type  
    security_groups = [aws_security_group.kaushikb_instance.id]  # Use TF Expression to add reference another resource creating implicit dependency.
    #e.g. use the security group dependency here

    user_data = var.user_data

    # Required when using a launch configuration with an auto scaling group. So that references can be repointed first to new
    # resource before deleting old ones
    lifecycle {
      create_before_destroy = true
      precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"    
    }
  }
}

## ASG Group definition
resource "aws_autoscaling_group" "kaushikb_as_group" {
    name = var.cluster_name

    launch_configuration    = aws_launch_configuration.kaushikbASG.name

    vpc_zone_identifier     = var.subnet_ids  # get the Subnet IDs to use in ASG Target Group integration with ALB so that it knows which instance to send requests to
    # Integrate with the ALB
    target_group_arns       = var.target_group_arns
    health_check_type       = var.health_check_type #default is EC2. ELB health_check instructs ASG to use target groups's health check to determine if the instance is healthy
    # else automatically replace it 

    min_size                    = var.min_size  #2
    max_size                    = var.max_size #10
    # desired_capacity            = 4
    # wait_for_capacity_timeout   = 15  # TF to wait till new instances register to the ELBs, else will rollback. Default is 10 mins
    
    # Use instance refresh to roll out changes so that zero-downtime is taken into account    
    instance_refresh {
        strategy = "Rolling"
        preferences {
          min_healthy_percentage = 50
        }      
    }
    tag {
        key                 = "Name"
        value               = var.cluster_name
        propagate_at_launch = true
    }  

    dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags:
      key => upper(value)
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }

    lifecycle {
    postcondition {
      condition     = length(self.availability_zones) > 1
      error_message = "You must use more than one AZ for high availability!"
    }
  }
}

resource "aws_autoscaling_schedule" "scale_up_during_business_hours" {
    count = var.enable_autoscaling ? 1 : 0  # if it's true use Autoscaling
    scheduled_action_name   = "scale_up_during_business_hours"
    min_size                = 2
    max_size                = 10
    desired_capacity        = 10
    recurrence              = "0 9 * * *"  # 09:00 Hrs every day 
    autoscaling_group_name  = module.WebServer.asg_name
}

resource "aws_autoscaling_schedule" "scale_down_after_business_hours" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name   = "scale_down_after_business_hours"
    min_size                = 2
    max_size                = 10
    desired_capacity        = 2
    recurrence              = "0 18 * * *"  # 18:00 Hrs every day
    autoscaling_group_name  = module.WebServer.asg_name
}

## Create a Security Group to override AWS EC2 default of no incoming/outgoin traffic
resource "aws_security_group" "kaushikb_instance" {
    name = "${var.cluster_name}-asg-instance"    # "KaushikTerraFormExample_instance"
}

# In Modules use External rules rather than Inline Blocks as these make it easier to add more rules from outside the modules
resource "aws_security_group_rule" "http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.kaushikb_instance.id
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips # CIDR = IP address Range, 0.0.0.0/0 allowed incoming on 8080 from any IP
}
resource "aws_security_group_rule" "http_outbound" {
    type = "egress"
    security_group_id = aws_security_group.kaushikb_instance.id
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips 
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.kaushikb_as_group.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}

data "aws_ec2_instance_type" "instance" {
  instance_type = var.instance_type
}

locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

