resource "helm_release" "external_secrets" {
  namespace        = "external-secrets"
  create_namespace = true

  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.12.1"

  set {
    name  = "installCRDs"
    value = false
  }
}


resource "kubernetes_manifest" "external_secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = "aws-secretsmanager"
      "namespace" = var.install_id
    }
    "spec" = {
      "provider" = {
        "aws" = {
          "service" = "SecretsManager"
          "region"  = var.region
          "auth" = {
            "jwt" = {
              "serviceAccountRef" = {
                "name" = "runner-${var.install_id}"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    resource.aws_iam_policy.external_secrets_role,
    resource.helm_release.external_secrets,
  ]

}
