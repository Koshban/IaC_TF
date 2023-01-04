# RDS DB Instance

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    # engine = "mysql"
    allocated_storage = 10  # 10 GB Storage
    instance_class = "db.t2.micro"
    skip_final_snapshot = true # The final snapshot is disabled, as this code is just for learning and testing (if you don’t disable the 
    # snapshot, or don’t provide a name for the snapshot via the final_snapshot_identifier parameter, destroy will fail)

    backup_retention_period = var.backup_retention_period  # Enable backups
    replicate_source_db = var.replicate_source_db  # Replica DB, if specified
    # db_name = "kaushikb_example_database"

    # Only set these params if replicate_source_db is not set
    engine   = var.replicate_source_db == null ? "mysql" : null
    db_name  = var.replicate_source_db == null ? var.db_name : null
    username = var.replicate_source_db == null ? var.db_username : null
    password = var.replicate_source_db == null ? var.db_password : null
}