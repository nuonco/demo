output "id" {
  value = resource.aws_db_subnet_group.rds_subnet.id
}

output "arn" {
  value = resource.aws_db_subnet_group.rds_subnet.arn
}

output "vpc_id" {
  value = resource.aws_db_subnet_group.rds_subnet.vpc_id
}
