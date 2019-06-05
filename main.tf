# Load Balancer
# Distributes traffic evenly across our container tasks
resource "aws_lb" "load_balancer" {
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.load_balancer.id]
  idle_timeout       = 300

  access_logs {
    enabled = true
    bucket  = var.access_logs_bucket
  }

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# Target group to forward incoming requests to
resource "aws_lb_target_group" "load_balancer" {
  depends_on  = ["aws_lb.load_balancer"]
  target_type = "ip"
  vpc_id      = var.vpc_id
  port        = var.target_group.port
  protocol    = var.target_group.protocol

  # Binds a client's session to a specific instance within the target group
  stickiness {
    # Only supported option is "lb_cookie"
    type    = "lb_cookie"
    enabled = var.target_group.stickiness_enabled
  }

  health_check {
    # Service health route for our API app
    path     = var.target_group.health_check_path
    interval = 60
  }

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# Intercepts incoming HTTPS requests and forwards them to our target group
resource "aws_lb_listener" "load_balancer" {
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener.port
  certificate_arn   = var.listener.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer.arn
  }
}

# Controls incoming and outgoing requests for associated instances
resource "aws_security_group" "load_balancer" {
  vpc_id = var.vpc_id

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# Creates security group rules if there are items in the cidr_block_security group list
resource "aws_security_group_rule" "load_balancer_cidr_blocks" {
  count             = length(var.cidr_block_security_groups)
  type              = var.cidr_block_security_groups[count.index].type
  from_port         = var.cidr_block_security_groups[count.index].from_port
  to_port           = var.cidr_block_security_groups[count.index].to_port
  protocol          = var.cidr_block_security_groups[count.index].protocol
  cidr_blocks       = var.cidr_block_security_groups[count.index].cidr_blocks
  ipv6_cidr_blocks  = var.cidr_block_security_groups[count.index].ipv6_cidr_blocks
  security_group_id = aws_security_group.load_balancer.id
}

# Creates security group rules if there are items in the source_security group list
resource "aws_security_group_rule" "load_balancer_source_security_group_ids" {
  count                    = length(var.source_security_groups)
  type                     = var.source_security_groups[count.index].type
  from_port                = var.source_security_groups[count.index].from_port
  to_port                  = var.source_security_groups[count.index].to_port
  protocol                 = var.source_security_groups[count.index].protocol
  source_security_group_id = var.source_security_groups[count.index].source_security_group_id
  security_group_id        = aws_security_group.load_balancer.id
}
