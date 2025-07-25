#
# Install Clickhouse Operator CRDs
#

locals {
  external_secrets_manifests = toset([
    "https://raw.githubusercontent.com/external-secrets/external-secrets/v0.18.2/deploy/crds/bundle.yaml"
  ])
}

data "http" "external_secrets_crd_raw" {
  for_each = local.external_secrets_manifests
  url      = each.key
}

data "kubectl_file_documents" "external_secrets_crd_doc" {
  for_each = data.http.external_secrets_crd_raw
  content  = each.value.response_body
}

locals {
  all_es_manifests = merge([
    for src in data.kubectl_file_documents.external_secrets_crd_doc :
    src.manifests
  ]...)
}

resource "kubectl_manifest" "external_secrets_crds" {
  for_each          = local.all_es_manifests
  server_side_apply = true
  yaml_body         = each.value
  sensitive_fields  = ["metadata.annotations.kubectl.kubernetes.io/last-applied-configuration", ]
}

# helm releAse
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  skip_crds        = true

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.18.2"
}
