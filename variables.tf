variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "access_logs_bucket" {
  type        = string
  description = "Bucket used for storing access logs"
}

variable "vpc_id" {
  type        = string
  description = "Remote state"
}

variable "resource_name_tag" {
  type        = string
  description = "Resource Name tag"
}

variable "resource_environment_tag" {
  type        = string
  description = "Resource Environment tag"
}

variable "target_group" {
  type        = map(any)
  description = "Target groups are forwarded requests from the load balancer. Accepts these props: protocol (HTTP or HTTPS), port, stickiness_enabled, health_check_path"
}

variable "listener" {
  type        = map(any)
  description = "Listeners handle requests on specific load balancer ports. Accepts these props: port, protocol (HTTP or HTTPS), certificate_arn"
}

variable "cidr_block_security_groups" {
  type        = list(map(any))
  description = "Security groups for CIDR blocks. Accept these props: from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks"
  default     = []
}

variable "source_security_groups" {
  type        = list(map(any))
  description = "Security groups for source security group ids. Accept these props: type, from_port, to_port, protocol, source_security_group_id"
  default     = []
}
