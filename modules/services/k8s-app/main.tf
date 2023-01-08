locals {
  pod_labels = {
    app = var.name
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
  }
  spec {
    replicas = var.replicas

# Pods Template, which specifies what container(s) to run, the ports to use, environment variables to set, and so on
    template {
      metadata {
        labels = local.pod_labels
      }

      spec { # define one or more container blocks to specify which Docker containers to run in this Pod
        container {  
          name  = var.name
          image = var.image

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.environment_variables
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }
  }
  selector {
      match_labels = local.pod_labels
    }
}
# Define a K8s Service, in this case for a LB
resource "kubernetes_service" "app" {
  metadata {
    name = var.name
  }

  spec {
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = var.container_port
      protocol    = "TCP"
    }
    selector = local.pod_labels
  }
}



