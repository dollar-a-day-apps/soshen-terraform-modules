# Used for write operations
output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.redis.configuration_endpoint_address
}

# Used for read operations (upon failure, a new node will be promoted to primary)
output "member_clusters" {
  value = aws_elasticache_cluster.redis.member_clusters
}

output "security_group_id" {
  value = module.security_group.id
}
