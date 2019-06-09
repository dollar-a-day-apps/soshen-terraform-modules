output "cluster_name" {
  value = aws_ecs_cluster.container.name
}

output "service_name" {
  value = aws_ecs_service.container.name
}

output "security_group_id" {
  value = module.security_group.id
}

