resource "aws_route53_record" "cname" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [module.ingress.dns_name]
}
