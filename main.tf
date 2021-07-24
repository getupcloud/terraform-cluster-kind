module "cluster" {
  source = "github.com/getupcloud/terraform-module-kind?ref=main"

  name               = var.name
  kubernetes_version = var.kubernetes_version
}

module "kubeconfig" {
  source     = "github.com/getupcloud/terraform-module-kubeconfig?ref=main"

  cluster_name = module.cluster.name
  command      = var.get_kubeconfig_command
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=main"

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.name}/kind/manifests"

}
