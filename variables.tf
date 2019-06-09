variable "vpc_id" {
  type = string
  description = "ID of the VPC"
}

variable "cidr_block_security_group_rules" {
  type = list(map(string))
  description = "Security group rules for moderating ingress/egress via CIDR blocks"
  default = []
}

variable "source_security_group_rules" {
  type = list(map(string))
  description = "Security group rules for moderating ingress/egress via external security group IDs"
  default = []
}
