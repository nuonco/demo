module "service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.11.0"

  name        = var.service_name
  cluster_arn = var.cluster_arn

  desired_count = 3
  cpu           = 1024
  memory        = 4096

  container_definitions = {
    api = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "${var.image_url}:${var.image_tag}"
      port_mappings = [
        {
          name          = "http"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "http"
        }
      ]
      memory_reservation = 100
      environment = [
        {
          name  = "NUON_APP_ID"
          value = var.app_id
        },
        {
          name  = "NUON_ORG_ID"
          value = var.org_id
        },
        {
          name  = "NUON_INSTALL_ID"
          value = var.install_id
        },
      ]
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.ingress.target_groups["api"].arn
      container_name   = "api"
      container_port   = var.container_port
    }
  }

  subnet_ids = data.aws_subnets.private.ids
  security_group_rules = {
    ingress_http = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.ingress.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Terraform   = "true"
    ServiceName = var.service_name
  }
}
