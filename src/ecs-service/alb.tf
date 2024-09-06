module "ingress" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.10.0"

  name                       = var.service_name
  vpc_id                     = var.vpc_id
  subnets                    = data.aws_subnets.public.ids
  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.cert.acm_certificate_arn

      forward = {
        target_group_key = "api"
      }
    }
  }

  target_groups = {
    api = {
      name_prefix                       = "api"
      protocol                          = "HTTP"
      backend_port                      = var.container_port
      target_type                       = "ip"
      create_attachment                 = false
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        interval            = 10
        path                = "/livez"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  tags = {
    Terraform   = "true"
    ServiceName = var.service_name
  }
}
