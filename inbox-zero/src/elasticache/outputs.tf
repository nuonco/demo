output "redis_cluster_id" {
  description = "Redis cluster ID"
  value       = aws_elasticache_cluster.redis.cluster_id
}

output "redis_cluster_arn" {
  description = "Redis cluster ARN"
  value       = aws_elasticache_cluster.redis.arn
}

output "redis_endpoint" {
  description = "Redis cluster endpoint (host:port)"
  value       = "${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
}

output "redis_host" {
  description = "Redis cluster host address"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  description = "Redis cluster port"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].port
}

output "redis_security_group_id" {
  description = "Security group ID for Redis cluster"
  value       = aws_security_group.redis.id
}

output "redis_connection_string" {
  description = "Redis connection string (redis://host:port)"
  value       = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
}
