# Service config
variable "container_port" {
  default = 8080
}

variable "service_name" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "image_url" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "app_id" {
  type = string
}

variable "org_id" {
  type = string
}

variable "install_id" {
  type = string
}

# Load balancer config

variable "vpc_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}
