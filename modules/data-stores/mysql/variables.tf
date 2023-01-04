variable "db_name" {
  description = "Name for the DB."
  type        = string
  default     = null
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true # This ensures Terraform won’t log the values when you run plan or apply
  default     = null  # To enable backup DB as that is AWS managed and doesnt take user parameters
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true  # This ensures Terraform won’t log the values when you run plan or apply
  default     = null
}

# To setup backup Region and multi Region retention
variable "backup_retention_period" {  # To be used on the Primary DB to enable replication
  description = "Days to retain backups. Must be > 0 to enable replication."
  type        = number
  default     = null
}

variable "replicate_source_db" {  # Replication DB
  description = "If specified, replicate the RDS database at the given ARN."
  type        = string
  default     = null
}