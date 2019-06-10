output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "security_group_id" {
  value = aws_security_group.redis.id
}
