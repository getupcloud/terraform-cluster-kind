module "cluster" {
  source = "github.com/getupcloud/terraform-module-kind?ref=main"

  name               = var.name
  kubernetes_version = var.kubernetes_version
}

module "kubeconfig" {
  source     = "github.com/getupcloud/terraform-module-kubeconfig?ref=main"

  cluster_name = module.cluster.name
  command      = var.kubeconfig_get_kubeconfig_command
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=main"

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.name}/kind/manifests"
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=main"

  cluster_name  = module.cluster.cluster_id
  customer_name = var.customer
  suffix        = "kind"
  tags          = []
  pagerduty_key = var.cronitor_pagerduty_key
  api_key       = var.cronitor_api_key
  api_endpoint  = module.cluster.cluster_endpoint
}

