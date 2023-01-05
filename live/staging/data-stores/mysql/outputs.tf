# output "address" {
#     value = aws_db_instance.example.address
#     description = "DB connection endpoint"  
# }

# output "port" {
#     value = aws_db_instance.example.port
#     description = "The port the database is listening on"  
# }

output "primary_address" {
  value       = module.mysql_primary.address
  description = "Connect to the primary database at this endpoint"
}

output "primary_port" {
  value       = module.mysql_primary.port
  description = "The port the primary database is listening on"
}

output "primary_arn" {
  value       = module.mysql_primary.arn
  description = "The ARN of the primary database"
}

