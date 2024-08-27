terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.19"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    kubernetes = {
      version = "~> 2.8"
    }

    kustomization = {
      source  = "kbst/kustomization"
      version = "< 1"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1"
    }
  }
}
