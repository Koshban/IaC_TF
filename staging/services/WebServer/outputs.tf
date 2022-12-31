# Output variables
output "public_ip" {
    value       = aws_instance.kaushikb.public_ip
    description = "Public IP4 IP of the instance created"
}

output "alb_dns_name" {
    value       = aws_lb.kaushikb_lb.dns_name
    description = "Domain Name/DNS of the Load Balancer"
}