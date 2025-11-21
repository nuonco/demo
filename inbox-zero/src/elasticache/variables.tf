locals {
  prefix             = "inbox-zero-${var.nuon_install_id}"
  private_subnet_ids = data.aws_subnets.private.ids
  redis_node_type    = var.redis_node_type
  tags               = var.tags
}


variable "region" {
  description = "AWS Region"
  type        = string
}

variable "nuon_install_id" {
  description = "Nuon Install ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Redis cluster will be deployed"
  type        = string
}

variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "Number of cache nodes in the cluster"
  type        = number
  default     = 1
}

variable "redis_parameter_group_family" {
  description = "Redis parameter group family"
  type        = string
  default     = "redis7"
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
