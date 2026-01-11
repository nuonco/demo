locals {
  name      = "explody-component"
  namespace = "too-large"
}

variable "datadog_api_key" {
  type        = string
  description = "The datadog api key - used by the agents."
}

variable "datadog_app_key" {
  type        = string
  description = "The datadog app key - used by the agents."
}

variable "install_id" {
  type        = string
  description = "Nuon Install ID"
}

# Cluster Info
variable "region" {
  type        = string
  description = "AWS Region"
}

variable "cluster_name" {
  type        = string
  description = "AWS EKS Cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "AWS EKS Cluster Endpoint"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "AWS EKS Cluster CA Data"
}

