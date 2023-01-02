module "WebServer" {
    source = "../../../modules/services/WebServer"
    cluster_name = "webserver-cluster"
    db_remote_state_bucket = "s3-prod"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"  
    instance_type   = "m4.large"  # micro for Staging, Macro for Prod
    min_size        = 4
    max_size        = 10
    custom_tags     = {
        Owner       = "KaushikB"
        ManagedBy   = "TF"
    }
}

resource "aws_autoscaling_schedule" "scale_up_during_business_hours" {
    scheduled_action_name   = "scale_up_during_business_hours"
    min_size                = 2
    max_size                = 10
    desired_capacity        = 10
    recurrence              = "0 9 * * *"  # 09:00 Hrs every day 
    autoscaling_group_name  = module.WebServer.asg_name
}

resource "aws_autoscaling_schedule" "scale_down_after_business_hours" {
    scheduled_action_name   = "scale_down_after_business_hours"
    min_size                = 2
    max_size                = 10
    desired_capacity        = 2
    recurrence              = "0 18 * * *"  # 18:00 Hrs every day
    autoscaling_group_name  = module.WebServer.asg_name
}


    

  
