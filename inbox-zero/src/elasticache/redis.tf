# ElastiCache Redis Cluster

# Security group for Redis
resource "aws_security_group" "redis" {
  name        = "${local.prefix}-redis"
  description = "Security group for ElastiCache Redis cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    description = "Allow Redis traffic from within VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-redis"
    }
  )
}

# Subnet group for Redis
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${local.prefix}-redis"
  subnet_ids = local.private_subnet_ids

  tags = local.tags
}

# Parameter group for Redis
resource "aws_elasticache_parameter_group" "redis" {
  name   = "${local.prefix}-redis"
  family = var.redis_parameter_group_family

  tags = local.tags
}

# ElastiCache Redis cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${local.prefix}-redis"
  engine               = "redis"
  engine_version       = var.redis_engine_version
  node_type            = local.redis_node_type
  num_cache_nodes      = var.redis_num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.redis.name
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]
  port                 = 6379

  tags = local.tags
}
