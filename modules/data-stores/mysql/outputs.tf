output "address" {
    value       = aws_db_instance.example.address
    description = "DB connection endpoint"  
}

output "port" {
    value       = aws_db_instance.example.port
    description = "The port the database is listening on"  
}

output "arn" {
    value       = aws_db_instance.example.arn
    description = "The ARN of the database"
}