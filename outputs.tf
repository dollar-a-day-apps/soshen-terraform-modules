output "cluster_name" {
  value = "${aws_ecs_cluster.container.name}"
}

output "service_name" {
  value = "${aws_ecs_service.container.name}"
}

output "security_group_id" {
  value = "${aws_security_group.container.id}"
}