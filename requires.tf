terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1"
    }
  }
}
