resource "kind_cluster" "cluster" {
  name            = var.cluster_name
  kubeconfig_path = local.kubeconfig_filename
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role                   = "control-plane"
      image                  = local.kind_image
      kubeadm_config_patches = var.kubeadm_config_patches.master
    }

    node {
      role                   = "worker"
      image                  = local.kind_image
      kubeadm_config_patches = var.kubeadm_config_patches.infra
    }

    node {
      role                   = "worker"
      image                  = local.kind_image
      kubeadm_config_patches = var.kubeadm_config_patches.app
    }
  }
}

module "kubeconfig" {
  source     = "github.com/getupcloud/terraform-module-kubeconfig?ref=v1.0"
  depends_on = [kind_cluster.cluster]

  cluster_name = kind_cluster.cluster.name
  command      = var.get_kubeconfig_command
  kubeconfig   = local.kubeconfig_filename
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=v1.10"
  #  depends_on = [module.kubeconfig]

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.cluster_name}/kind/manifests"
  wait           = var.flux_wait
  flux_version   = var.flux_version

  manifests_template_vars = merge(
    {
      alertmanager_cronitor_id : try(module.cronitor.cronitor_id, "")
      alertmanager_opsgenie_integration_api_key : try(module.opsgenie.api_key, "")
      modules : var.kind_modules
      modules_output : {}
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
  api_endpoint     = local.api_endpoint
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
