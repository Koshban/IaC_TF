# RDS DB Instance

module "mysql_primary" {
    source      = "../../../../modules/data-stores/mysql"
    providers = {
      aws = aws.r1-sng
     }
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    # Must be enabled to support replication
    backup_retention_period = 1  
}

module "mysql_replica" {
    source      = "../../../../modules/data-stores/mysql"
    providers = {
      aws = aws.r2-tky
     }
    # Replica of Prod DB
    replicate_source_db = module.mysql_primary.arn        
} 
