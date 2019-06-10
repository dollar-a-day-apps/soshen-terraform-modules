# Load Balancer
# Distributes traffic evenly across our container tasks
resource "aws_lb" "load_balancer" {
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups = [module.security_group.id]
  idle_timeout    = 300

  access_logs {
    enabled = true
    bucket  = var.access_logs_bucket
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = "${var.tags.Description} application load balancer"
  }
}

# Target group to forward incoming requests to
resource "aws_lb_target_group" "load_balancer" {
  depends_on  = [aws_lb.load_balancer]
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

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = var.tags.Name
    Environment = var.tags.Environment
    Description = "${var.tags.Description} application load balancer"
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

  lifecycle {
    create_before_destroy = true
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
    Description = "${var.tags.Description} application load balancer"
  }
}

