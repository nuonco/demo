locals {
  datadog = {
    value_file = "values/datadog.yaml"
  }
}

resource "helm_release" "datadog" {
  name             = "datadog"
  namespace        = "datadog"
  create_namespace = true

  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  version    = "3.54.2"

  values = [
    file(local.datadog.value_file),
    yamlencode({
      datadog = {
        apiKey      = var.datadog_api_key
        tags        = ["env:test"]
        clusterName = var.cluster_name
      }
    })
  ]
}
