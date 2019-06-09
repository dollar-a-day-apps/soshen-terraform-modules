resource "aws_security_group" "security_group" {
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ingress", "egress"]
  }

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

resource "aws_security_group_rule" "cidr_block" {
  security_group_id        = aws_security_group.security_group.id

  count                    = length(var.cidr_block_security_group_rules)
  type                     = var.cidr_block_security_group_rules[count.index][type]
  protocol                 = var.cidr_block_security_group_rules[count.index][protocol]
  from_port                = var.cidr_block_security_group_rules[count.index][from_port]
  to_port                  = var.cidr_block_security_group_rules[count.index][to_port]
  source_security_group_id = var.cidr_block_security_group_rules[count.index][ipv6_cidr_block]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "source_security_group" {
  security_group_id        = aws_security_group.security_group.id

  count                    = length(var.source_security_group_rules)
  type                     = var.source_security_group_rules[count.index][type]
  protocol                 = var.source_security_group_rules[count.index][protocol]
  from_port                = var.source_security_group_rules[count.index][from_port]
  to_port                  = var.source_security_group_rules[count.index][to_port]
  source_security_group_id = var.source_security_group_rules[count.index][source_security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

