locals {
  api_endpoint               = kind_cluster.cluster.endpoint
  certificate_authority_data = kind_cluster.cluster.cluster_ca_certificate
  client_certificate_data    = kind_cluster.cluster.client_certificate
  client_key_data            = kind_cluster.cluster.client_key
  kubeconfig_filename        = abspath(pathexpand(var.kubeconfig_filename))

  # https://github.com/kubernetes-sigs/kind/releases
  kind_image_versions = {
    "1.31" : "kindest/node:v1.31.0@sha256:53df588e04085fd41ae12de0c3fe4c72f7013bba32a20e7325357a1ac94ba865"
    "1.30" : "kindest/node:v1.30.4@sha256:976ea815844d5fa93be213437e3ff5754cd599b040946b5cca43ca45c2047114"
    "1.29" : "kindest/node:v1.29.8@sha256:d46b7aa29567e93b27f7531d258c372e829d7224b25e3fc6ffdefed12476d3aa"
    "1.28" : "kindest/node:v1.28.13@sha256:45d319897776e11167e4698f6b14938eb4d52eb381d9e3d7a9086c16c69a8110"
    "1.27" : "kindest/node:v1.27.17@sha256:3fd82731af34efe19cd54ea5c25e882985bafa2c9baefe14f8deab1737d9fabe"
    "1.26" : "kindest/node:v1.26.15@sha256:1cc15d7b1edd2126ef051e359bf864f37bbcf1568e61be4d2ed1df7a3e87b354"
    "1.25" : "kindest/node:v1.25.16@sha256:6110314339b3b44d10da7d27881849a87e092124afab5956f2e10ecdb463b025"
  }

  kind_image = lookup(local.kind_image_versions, var.kubernetes_version)

  modules_result = {
    for name, config in merge(var.modules, local.modules) : name => merge(config, {
      output : config.enabled ? lookup(local.register_modules, name, try(config.output, tomap({}))) : tomap({})
    })
  }

  manifests_template_vars = merge(
    var.manifests_template_vars,
    {
      alertmanager_cronitor_id : var.cronitor_id
      alertmanager_opsgenie_integration_api_key : var.opsgenie_integration_api_key
      modules : local.modules_result
    },
    module.teleport-agent.teleport_agent_config,
    { for k, v in var.manifests_template_vars : k => v if k != "modules" }
  )
}
