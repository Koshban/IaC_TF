module "WebServer" {
    source                  = "../../../modules/services/WebServer"
    cluster_name            = "webserver-cluster"
    db_remote_state_bucket  = "s3-staging"
    db_remote_state_key     = "staging/data-stores/mysql/terraform.tfstate"  

    instance_type   = "t2.micro"  # micro for Staging, Macro for Prod
    min_size        = 2
    max_size        = 2
}