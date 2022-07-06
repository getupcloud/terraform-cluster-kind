module "cluster" {
  source = "github.com/getupcloud/terraform-module-kind?ref=v2.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
}

module "kubeconfig" {
  source = "github.com/getupcloud/terraform-module-kubeconfig?ref=v1.0"

  cluster_name = module.cluster.name
  command      = var.get_kubeconfig_command
}

module "flux" {
  source     = "github.com/getupcloud/terraform-module-flux?ref=v1.10"
  depends_on = [module.cluster]

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${module.cluster.name}/kind/manifests"
  wait           = var.flux_wait
  flux_version   = var.flux_version

  manifests_template_vars = merge(
    {
      alertmanager_cronitor_id : try(module.cronitor.cronitor_id, "")
      alertmanager_opsgenie_integration_api_key : try(module.opsgenie.api_key, "")
    },
    module.teleport-agent.teleport_agent_config,
    var.manifests_template_vars
  )
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=v1.3"

  cronitor_enabled = var.cronitor_enabled
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  suffix           = "kind"
  tags             = ["local"]
  pagerduty_key    = var.cronitor_pagerduty_key
  api_endpoint     = module.cluster.api_endpoint
}

module "opsgenie" {
  source = "github.com/getupcloud/terraform-module-opsgenie?ref=main"

  opsgenie_enabled = var.opsgenie_enabled
  customer_name    = var.customer_name
  owner_team_name  = var.opsgenie_team_name
}

module "teleport-agent" {
  source = "github.com/getupcloud/terraform-module-teleport-agent-config?ref=v0.3"

  auth_token       = var.teleport_auth_token
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  cluster_provider = "kind"
  cluster_region   = var.region
}
