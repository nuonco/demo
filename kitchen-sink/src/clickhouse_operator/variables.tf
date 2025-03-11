variable "iam_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "operator_version" {
  type    = string
  default = "0.24.4"
}

