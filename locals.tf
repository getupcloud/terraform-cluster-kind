locals {
  api_endpoint               = module.cluster.api_endpoint
  certificate_authority_data = module.cluster.certificate_authority_data
  client_certificate_data    = module.cluster.client_certificate_data
  client_key_data            = module.cluster.client_key_data
  kubeconfig                 = module.kubeconfig.kubeconfig
}
