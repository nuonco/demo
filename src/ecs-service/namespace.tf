resource "aws_service_discovery_http_namespace" "this" {
  name        = var.service_name
  description = "CloudMap namespace for ${var.service_name}"
}
