module "WebServer" {
    source                  = "../../../modules/services/WebServer"
    cluster_name            = "webserver-cluster"
    db_remote_state_bucket  = "s3-prod"
    db_remote_state_key     = "prod/data-stores/mysql/terraform.tfstate"  
    instance_type           = "m4.large"  # micro for Staging, Macro for Prod
    min_size                = 4
    max_size                = 10
    enable_autoscaling      = true 
    custom_tags     = {
        Owner       = "KaushikB"
        ManagedBy   = "TF"
    }
}



    

  
