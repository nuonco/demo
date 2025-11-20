# Note: ECS cluster is provided via var.ecs_cluster_id
# The cluster is created by the ecs_cluster component

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "builder" {
  name              = "/ecs/inbox-zero-${var.nuon_install_id}/${var.name_prefix}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# Security Group
resource "aws_security_group" "builder" {
  name        = "${var.name_prefix}-task"
  description = "Security group for builder Fargate task"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic for git clone, ECR, and npm packages"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-task"
    }
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "builder" {
  family                   = var.name_prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name       = "git-clone"
      image      = "alpine/git:latest"
      essential  = false
      entryPoint = ["/bin/sh", "-c"]
      command = [
        "git clone --single-branch --depth=1 --branch=$BRANCH $GIT_REPO_URL /workspace"
      ]
      environment = [
        {
          name  = "GIT_REPO_URL"
          value = var.git_repo_url
        },
        {
          name  = "BRANCH"
          value = var.git_branch
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "workspace"
          containerPath = "/workspace"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.builder.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "git-clone"
        }
      }
    },
    {
      name       = "kaniko"
      image      = "gcr.io/kaniko-project/executor:debug"
      essential  = true
      entryPoint = ["/busybox/sh", "-c"]
      command = [
        "/kaniko/executor --dockerfile=/workspace/${var.dockerfile_path} --context=dir:///workspace --destination=${var.ecr_registry}/${var.ecr_repository}:$${IMAGE_TAG:-latest} --build-arg=$${BUILD_ARGS:-}"
      ]
      environment = [
        {
          name  = "IMAGE_TAG"
          value = "latest"
        },
        {
          name  = "BUILD_ARGS"
          value = ""
        },
        {
          name  = "AWS_REGION"
          value = data.aws_region.current.name
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "workspace"
          containerPath = "/workspace"
        }
      ]
      dependsOn = [
        {
          containerName = "git-clone"
          condition     = "SUCCESS"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.builder.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "kaniko"
        }
      }
    }
  ])

  volume {
    name = "workspace"
  }

  tags = var.tags
}
