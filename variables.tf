variable "vpc_id" {
  type = string
  description = "ID of the VPC"
}

variable "cidr_block_security_group_rules" {
  type = list(map(string))
  description = "Security group rules for moderating ingress/egress via CIDR blocks. Accepts the following props: type, protocol, from_port, to_port, cidr_block, ipv6_cidr_block"
  default = []
}

variable "source_security_group_rules" {
  type = list(map(string))
  description = "Security group rules for moderating ingress/egress via external security group IDs. Accepts the following props: type, protocol, from_port, to_port, source_security_group_id"
  default = []
}
