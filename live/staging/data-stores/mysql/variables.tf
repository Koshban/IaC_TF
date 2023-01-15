# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true # This ensures Terraform won’t log the values when you run plan or apply
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true  # This ensures Terraform won’t log the values when you run plan or apply
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "kaushikb_database_staging"
}