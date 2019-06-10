variable "load_balancer_internal" {
  type = bool
  description = "Determines whether the load balancer is publicly accessible"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "Remote state"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Accepts the following props: Name, Environment, Description"
}

variable "target_group" {
  type        = map(string)
  description = "Target groups are forwarded requests from the load balancer. Accepts these props: protocol (HTTP or HTTPS), port, stickiness_enabled, health_check_path"
}

variable "listener" {
  type        = map(string)
  description = "Listeners handle requests on specific load balancer ports. Accepts these props: port, protocol (HTTP or HTTPS), certificate_arn"
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
