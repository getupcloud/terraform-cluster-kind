locals {
  api_endpoint               = kind_cluster.cluster.endpoint
  certificate_authority_data = kind_cluster.cluster.cluster_ca_certificate
  client_certificate_data    = kind_cluster.cluster.client_certificate
  client_key_data            = kind_cluster.cluster.client_key
  kubeconfig_filename        = abspath(pathexpand(var.kubeconfig_filename))

  # https://github.com/kubernetes-sigs/kind/releases
  kind_image_versions = {
    "1.23" : "kindest/node:v1.23.4@sha256:0e34f0d0fd448aa2f2819cfd74e99fe5793a6e4938b328f657c8e3f81ee0dfb9"
    "1.22" : "kindest/node:v1.22.7@sha256:1dfd72d193bf7da64765fd2f2898f78663b9ba366c2aa74be1fd7498a1873166"
    "1.21" : "kindest/node:v1.21.10@sha256:84709f09756ba4f863769bdcabe5edafc2ada72d3c8c44d6515fc581b66b029"
    "1.20" : "kindest/node:v1.20.15@sha256:393bb9096c6c4d723bb17bceb0896407d7db581532d11ea2839c80b28e5d8deb"
    "1.19" : "kindest/node:v1.19.16@sha256:81f552397c1e6c1f293f967ecb1344d8857613fb978f963c30e907c32f598467"
    "1.18" : "kindest/node:v1.18.20@sha256:e3dca5e16116d11363e31639640042a9b1bd2c90f85717a7fc66be34089a8169"
    "1.17" : "kindest/node:v1.17.17@sha256:e477ee64df5731aa4ef4deabbafc34e8d9a686b49178f726563598344a3898d5"
    "1.16" : "kindest/node:v1.16.15@sha256:64bac16b83b6adfd04ea3fbcf6c9b5b893277120f2b2cbf9f5fa3e5d4c2260cc"
    "1.15" : "kindest/node:v1.15.12@sha256:9dfc13db6d3fd5e5b275f8c4657ee6a62ef9cb405546664f2de2eabcfd6db778"
    "1.14" : "kindest/node:v1.14.10@sha256:b693339da2a927949025869425e20daf80111ccabf020d4021a23c00bae29d82"
  }

  kind_image = lookup(local.kind_image_versions, var.kubernetes_version)
}
