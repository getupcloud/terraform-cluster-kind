provider "shell" {
  enable_parallelism = true
  interpreter        = ["/bin/bash", "-c"]
}

provider "kubectl" {
  load_config_file       = false
  host                   = local.api_endpoint
  cluster_ca_certificate = local.certificate_authority_data != "" ? base64decode(local.certificate_authority_data) : null
  client_certificate     = local.client_certificate_data != "" ? base64decode(local.client_certificate_data) : null
  client_key             = local.client_key_data != "" ? base64decode(local.client_key_data) : null
  apply_retry_count      = 2
}
