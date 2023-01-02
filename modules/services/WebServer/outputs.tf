# Output variables
output "public_ip" {
    value       = aws_instance.kaushikb.public_ip
    description = "Public IP4 IP of the instance created"
}

output "asg_name" {
    value = aws_autoscaling_group.kaushikb_as_group.name
    description = "Auto Scaling groups Name"  
}

output "alb_dns_name" {
    value = aws_lb.kaushikb_lb.dns_name
    description = "DNS of the Load Balancer"  
}

output "alb_security_group_id" {
    value = aws_security_group.kaushikb_lb_sg_instance.id 
    description = "The ID of the Security Group attached to the load balancer"  
}