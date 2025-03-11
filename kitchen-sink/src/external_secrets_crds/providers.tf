provider "aws" {}

provider "kubectl" {
  load_config_file = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--role-arn", var.iam_role_arn]
  }
}
