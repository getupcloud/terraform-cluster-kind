provider "kind" {
}

provider "kubernetes" {
  config_path            = var.use_kubeconfig ? var.kubeconfig_filename : null
  host                   = var.use_kubeconfig ? null : local.api_endpoint
  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
  client_certificate     = var.use_kubeconfig ? null : local.client_certificate_data
  client_key             = var.use_kubeconfig ? null : local.client_key_data
}

provider "kubectl" {
  load_config_file       = var.use_kubeconfig ? null : false
  host                   = var.use_kubeconfig ? null : local.api_endpoint
  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
  client_certificate     = var.use_kubeconfig ? null : local.client_certificate_data
  client_key             = var.use_kubeconfig ? null : local.client_key_data
  apply_retry_count      = 2
}
