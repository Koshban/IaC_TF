output "alb_dns_name" {
    value = module.WebServer.alb_dns_name
    description = "DNS of the Load Balancer"  
}