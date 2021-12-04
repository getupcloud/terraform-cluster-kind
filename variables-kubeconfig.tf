## Starting - auto-generated by ../managed-cluster/managed-cluster from ../terraform-module-kubeconfig/variables.tf
variable "kubeconfig_cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "kubeconfig_command" {
  description = "Command to retrieve/generate current kubeconfig"
  type        = string
  default     = "/bin/true"
}

variable "kubeconfig_kubeconfig" {
  description = "Kubeconfig filename."
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_hash_command" {
  description = "Command to hash current kubeconfig. Must print json object only."
  type        = string
  default     = <<-EOF
    if [ -e $KUBECONFIG ]; then
      MD5=$(md5sum $KUBECONFIG | cut -f1 -d ' ')
    else
      MD5=$(echo -n | md5sum | cut -f1 -d ' ')
    fi &>/dev/null
    echo "{\"md5sum\":\"$MD5\"}"
  EOF
}
## Finished - auto-generated by ../managed-cluster/managed-cluster from ../terraform-module-kubeconfig/variables.tf
