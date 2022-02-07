module "cluster" {
  source = "github.com/getupcloud/terraform-module-kind?ref=v1.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
}

module "kubeconfig" {
  source = "github.com/getupcloud/terraform-module-kubeconfig?ref=v1.0"

  cluster_name = module.cluster.name
  command      = var.get_kubeconfig_command
}

module "flux" {
  source     = "github.com/getupcloud/terraform-module-flux?ref=v1.0"
  depends_on = [module.cluster]

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${module.cluster.name}/kind/manifests"
  wait           = var.flux_wait
  flux_version   = var.flux_version

  manifests_template_vars = merge({
    alertmanager_cronitor_id : module.cronitor.cronitor_id
  }, var.manifests_template_vars)
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=v1.0"

  cluster_name  = var.cluster_name
  customer_name = var.customer_name
  cluster_sla   = var.cluster_sla
  suffix        = "kind"
  tags          = ["local"]
  pagerduty_key = var.cronitor_pagerduty_key
  api_key       = var.cronitor_api_key
  api_endpoint  = module.cluster.api_endpoint
}
