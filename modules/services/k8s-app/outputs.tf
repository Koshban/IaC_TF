output "service_status" {
  value       = kubernetes_service.app.status
  description = "The K8S Service status"
}

# expose the Service endpoint (the load balancer hostname)
locals {
  status = kubernetes_service.app.status
}

# The LB Status will look like this below, 
# [
#   {
#     load_balancer = [
#       {
#         ingress = [
#           {
#             hostname = "<HOSTNAME>"
#           }
#         ]
#       }
#     ]
#   }
# ]
# Hence the long winded way to get the Hostname
output "service_endpoint" {
  value = try(
    "http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}",
    "(error parsing hostname from status)"
  )
  description = "The K8S Service endpoint"
}