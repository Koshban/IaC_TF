# Output variables
output "public_ip" {
    value       = aws_instance.kaushikb.public_ip
    description = "Public IP4 IP of the instance created"
}

output "asg_name" {
    value = module.asg.asg_name
    description = "Auto Scaling groups Name"  
}

output "alb_dns_name" {
    value = module.alb.alb_dns_name
    description = "DNS of the Load Balancer"  
}

output "instance_security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "The ID of the EC2 Instance Security Group"
}