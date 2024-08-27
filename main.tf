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

      extra_port_mappings {
        container_port = 32080
        host_port      = var.http_port
      }

      extra_port_mappings {
        container_port = 32443
        host_port      = var.https_port
      }

      extra_port_mappings {
        container_port = 32022
        host_port      = var.ssh_port
      }
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
  source = "github.com/getupcloud/terraform-module-flux?ref=v2.5.1"
  #  depends_on = [module.kubeconfig]

  git_repo                = var.flux_git_repo
  manifests_path          = "./clusters/${var.cluster_name}/kind/manifests"
  wait                    = var.flux_wait
  flux_version            = var.flux_version
  flux_install_file       = var.flux_install_file
  manifests_template_vars = local.manifests_template_vars
  debug                   = var.dump_debug
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
