## Common variables

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_sla" {
  description = "Cluster SLA"
  type        = string
  default     = "none"
}

variable "customer_name" {
  description = "Customer name"
  type        = string
}

variable "region" {
  description = "Cluster Region"
  type        = string
  default     = "unknown"
}

variable "use_kubeconfig" {
  description = "Should kubernetes/kubectl providers use local kubeconfig or credentials from cloud module"
  type        = bool
  default     = false
}

variable "kubeconfig_filename" {
  description = "Kubeconfig path"
  default     = "~/.kube/config"
  type        = string
}

variable "get_kubeconfig_command" {
  description = "Command to create/update kubeconfig"
  default     = "kind export kubeconfig --name $CLUSTER_NAME"
}

variable "flux_git_repo" {
  description = "GitRepository URL."
  type        = string
  default     = ""
}

variable "flux_wait" {
  description = "Wait for all manifests to apply"
  type        = bool
  default     = true
}

variable "flux_version" {
  description = "Flux version to install"
  type        = string
  default     = "v0.15.3"
}

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}

variable "manifests_template_vars" {
  description = "Template vars for use by cluster manifests"
  type        = any
  default = {
    alertmanager_pagerduty_key : ""
    alertmanager_opsgenie_api_key : ""
  }
}

variable "cronitor_pagerduty_key" {
  description = "Cronitor PagerDuty key"
  type        = string
  default     = ""
}

variable "cronitor_api_key" {
  description = "Cronitor API key. Leave empty to destroy"
  type        = string
  default     = ""
}

variable "teleport_auth_token" {
  description = "Teleport Agent auth token"
  type        = string
  default     = ""
}

variable "pre_create" {
  description = "Scripts to execute before cluster is created."
  type        = list(string)
  default     = []
}

variable "post_create" {
  description = "Scripts to execute after cluster is created."
  type        = list(string)
  default     = []
}
