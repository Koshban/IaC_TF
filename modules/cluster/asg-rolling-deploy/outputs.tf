output "asg_name" {
  value       = aws_autoscaling_group.kaushikb_as_group.name
  description = "The name of the Auto Scaling Group"
}

output "instance_security_group_id" {
  value       = aws_security_group.kaushikb_instance.id
  description = "The ID of the EC2 Instance Security Group"
}