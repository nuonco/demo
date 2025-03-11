# aws details
variable "region" {
  type        = string
  description = "The aws region"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "The name of the eks cluster we're installing into."
}

variable "iam_role_arn" {
  type        = string
  description = "The IAM Role to get EKS credentials with/for."
  default     = ""
}


variable "install_id" {
  type        = string
  description = "{{.nuon.install.id}}"
  default     = ""
}
