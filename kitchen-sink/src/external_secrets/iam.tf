data "aws_iam_policy_document" "external_secrets_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets",
      "secretsmanager:BatchGetSecretValue"
    ]
    resources = ["*", ]
  }
}


resource "aws_iam_policy" "external_secrets_role" {
  name   = "external-secrets-${var.install_id}"
  policy = data.aws_iam_policy_document.external_secrets_policy.json
}
