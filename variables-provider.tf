## Provider specific variables

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.20"
}

variable "kubeadm_config_patches" {
  description = "Patches to apply on each node group"
  default = {
    master : []

    infra : [
      <<-EOT
      kind: JoinConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "role=infra"
    EOT
    ]

    app : [
      <<-EOT
      kind: JoinConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "role=app"
    EOT
    ]
  }
}
