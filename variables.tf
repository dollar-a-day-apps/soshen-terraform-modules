variable "redis" {
  type = map(string)
  description = "Redis Elasticache cluster and replication group configuration values. Accepts the following props: id, subnet_group_name, availability_zones, description, node_type, number_cache_clusters"
}

variable "tags" {
  type = map(string)
  description = "Resource tags. Accepts the following props: Name, Environment, Description"
}

variable "cidr_block_security_groups" {
  type        = list(map(string))
  description = "Security groups for CIDR blocks. Accept these props: from_port, to_port, protocol, cidr_block, ipv6_cidr_block"
  default     = []
}

variable "source_security_groups" {
  type        = list(map(string))
  description = "Security groups for source security group ids. Accept these props: type, from_port, to_port, protocol, source_security_group_id"
  default     = []
}
