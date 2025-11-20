variable "region" {
  description = "AWS Region"
  type        = string
}

variable "nuon_install_id" {
  description = "Nuon Install ID"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "inbox-zero"
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "KMS key ARN for encryption (only used if encryption_type is KMS)"
  type        = string
  default     = null
}

variable "lifecycle_policy_max_image_count" {
  description = "Maximum number of images to retain (untagged images older than this count are deleted)"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Additional tags to apply to the repository"
  type        = map(string)
  default     = {}
}
