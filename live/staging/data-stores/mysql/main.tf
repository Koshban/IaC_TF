# RDS DB Instance

# resource "aws_db_instance" "example" {
#     identifier_prefix = "terraform-up-and-running"
#     engine = "mysql"
#     allocated_storage = 10  # 10 GB Storage
#     instance_class = "db.t2.micro"
#     skip_final_snapshot = true # The final snapshot is disabled, as this code is just for learning and testing (if you don’t disable the 
#     # snapshot, or don’t provide a name for the snapshot via the final_snapshot_identifier parameter, destroy will fail)
#     db_name = "kaushikb_example_database"
#     # final_snapshot_identifier = ""

#     # Identifiers Master UserName and password
#     username = var.db_username
#     password = var.db_password
# }

# RDS DB Instance

module "mysql_primary" {
    source      = "../../../../modules/data-stores/mysql"
    providers = {
      aws = aws.r1-sng
     }
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
}