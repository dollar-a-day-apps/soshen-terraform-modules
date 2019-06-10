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
    Description = "${var.tags.Description} Redis"
  }
}

# Manages replications of our Redis cache and enables multi-AZ failover
resource "aws_elasticache_replication_group" "redis" {
  apply_immediately             = true
  automatic_failover_enabled    = true
  port                          = 6379
  engine                        = "redis"
  engine_version                = "5.0.4"
  parameter_group_name          = "default.redis5.0.cluster.on"
  availability_zones            = var.redis.availability_zones
  replication_group_id          = var.redis.id
  replication_group_description = var.redis.description
  node_type                     = var.redis.node_type
  subnet_group_name             = var.redis.subnet_group_name
  security_group_ids            = [aws_security_group.redis.id]

  # Backups of our data which we can use to restore Redis clusters and nodes
  snapshot_name            = var.redis.id
  snapshot_window          = "sun:07:00-sun:10:00"
  snapshot_retention_limit = 14

  cluster_mode {
    replicas_per_node_group = var.redis.replicas_per_node_group
    num_node_groups         = var.redis.num_node_groups
  }

  lifecycle = {
    create_before_destroy = true
  }

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = "${var.tags.Description} Redis"
  }
}

module "security_group" {
  source                          = "github.com/dollar-a-day-apps/soshen-terraform-modules?ref=security-group"
  vpc_id                          = var.vpc_id
  cidr_block_security_group_rules = var.cidr_block_security_groups
  source_security_group_rules     = var.source_security_groups

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = "${var.tags.Description} Redis"
  }
}
