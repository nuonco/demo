variable "region" {
  description = "AWS Region"
  type        = string
}
variable "ecr_registry" {
  description = "ECR registry URL (e.g., 123456789.dkr.ecr.us-east-1.amazonaws.com)"
  type        = string
}

variable "ecr_repository" {
  description = "ECR repository name"
  type        = string
}

variable "git_repo_url" {
  description = "Git repository URL (HTTPS)"
  type        = string
}

variable "dockerfile_path" {
  description = "Path to Dockerfile relative to repo root"
  type        = string
  default     = "docker/Dockerfile"
}

variable "vpc_id" {
  description = "VPC ID for Fargate task"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Fargate task (typically private subnets with NAT gateway)"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID (optional, creates one if not provided)"
  type        = string
  default     = null
}

variable "cpu" {
  description = "Fargate task CPU units (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "512"
}

variable "memory" {
  description = "Fargate task memory in MB (512, 1024, 2048, etc.)"
  type        = string
  default     = "1024"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 7
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "builder"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
