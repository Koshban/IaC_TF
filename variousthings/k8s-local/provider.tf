terraform {
  # required_version = ">= 1.0.0, < 2.0.0"
  required_version = "1.3.6"

  required_providers {
    kubernetes = {
      source  = "registry.terraform.io/hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
# Authenticate to Kubernetes running locally in Docker Desktop
# using your local kubeconfig file and docker-desktop config
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}