output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.builder.arn
}

output "task_execution_role_arn" {
  description = "ARN of the task execution role"
  value       = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  description = "ARN of the task IAM role"
  value       = aws_iam_role.task.arn
}

output "security_group_id" {
  description = "Security group ID for the builder task"
  value       = aws_security_group.builder.id
}

output "cluster_id" {
  description = "ECS cluster ID"
  value       = local.cluster_id
}

output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = local.cluster_arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.builder.name
}
