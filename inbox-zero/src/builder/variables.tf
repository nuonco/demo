locals {
  tags = {
    "app.nuon.co/name"    = "ingress-zero"
    "install.nuon.com/id" = var.nuon_install_id
  }
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "nuon_install_id" {
  description = "Nuon Install ID"
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
  default     = "https://github.com/elie222/inbox-zero"
}

variable "git_branch" {
  description = "Git repository branch"
  type        = string
  default     = "main"
}


variable "dockerfile_path" {
  description = "Path to Dockerfile relative to repo root"
  type        = string
  default     = "docker/Dockerfile"
}

variable "vpc_id" {
  description = "VPC ID for Fargate task security group"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID where the builder task will be registered"
  type        = string
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

