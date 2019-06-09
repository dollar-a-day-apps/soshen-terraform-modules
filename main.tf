resource "aws_elasticache_cluster" "redis" {
  apply_immediately    = true
  cluster_id           = var.redis.id
  subnet_group_name    = var.redis.subnet_group_name
  replication_group_id = aws_elasticache_replication_group.id
  security_group_ids   = [aws_security_group.redis.id]

  # Backups of our data which we can use to restore instances
  snapshot_name            = var.redis.id
  snapshot_window          = "sun:07:00-sun:10:00"
  snapshot_retention_limit = 14

  lifecycle = {
    create_before_destroy = true
  }

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = var.tags.Description
  }
}

# Manages replications of our Redis cache and enables multi-AZ failover
resource "aws_elasticache_replication_group" "redis" {
  apply_immediately             = true
  automatic_failover_enabled    = true
  port                          = 6379
  engine                        = "redis"
  engine_version                = "5.0.3"
  parameter_group_name          = "default.redis5.0"
  availability_zones            = var.redis.availability_zones
  replication_group_id          = var.redis.id
  replication_group_description = var.redis.description
  node_type                     = var.redis.node_type
  number_cache_clusters         = var.redis.number_cache_clusters
  subnet_group_name             = var.redis.subnet_group_name
  security_group_ids            = [aws_security_group.redis.id]

  # Backups of our data which we can use to restore Redis clusters and nodes
  snapshot_name            = var.redis.id
  snapshot_window          = "sun:07:00-sun:10:00"
  snapshot_retention_limit = 14

  lifecycle = {
    create_before_destroy = true
  }

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = var.tags.Description
  }
}

