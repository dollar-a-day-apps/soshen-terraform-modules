# Load Balancer
# Distributes traffic evenly across our container tasks
resource "aws_lb" "load_balancer" {
  internal           = var.load_balancer_internal
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [module.security_group.id]
  idle_timeout       = 300

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.load_balancer.id
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

# LOAD BALANCER ACCESS LOGS

# Provides us with the AWS account ID
data "aws_caller_identity" "load_balancer" {}

# Gets the AWS load balancer service account to enable logging for the S3 bucket
data "aws_elb_service_account" "load_balancer" {}

# IAM policy which allows the load balancer to insert logs into the private S3 bucket
data "aws_iam_policy_document" "load_balancer" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.load_balancer.id}/AWSLogs/${data.aws_caller_identity.load_balancer.account_id}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.load_balancer.arn]
    }
  }
}

resource "aws_s3_bucket" "load_balancer" {
  acl = "private"

  # Moves the log files to appropriate types of storage based on usage frequency to reduce cost
  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "AWSLogs/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
      Environment = var.tags.Environment
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  # Used to avoid deletion of critical resources
  lifecycle {
    create_before_destroy = true
  }

  # Deletes the bucket even if it has contents
  force_destroy = true
}

resource "aws_s3_bucket_policy" "load_balancer" {
  bucket = aws_s3_bucket.load_balancer.id
  policy = data.aws_iam_policy_document.load_balancer.json

  lifecycle {
    create_before_destroy = true
  }
}
