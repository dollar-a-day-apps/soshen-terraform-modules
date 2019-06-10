# Used for write operations
output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

# Used for read operations (upon failure, a new node will be promoted to primary)
output "cache_nodes" {
  value = aws_elasticache_cluster.redis.cache_nodes
}

output "security_group_id" {
  value = module.security_group.id
}
