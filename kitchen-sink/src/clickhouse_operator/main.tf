#
# Install Clickhouse Operator CRDs
#

resource "kubectl_manifest" "clickhouse_operator" {
  for_each  = local.all_manifests
  yaml_body = each.value
}
