# Container
# All the separate components necessary to operate our app's container instances

# AWS ECS - Cluster
resource "aws_ecs_cluster" "container" {
  name = var.ecs_cluster_name

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# AWS ECS - Service
resource "aws_ecs_service" "container" {
  desired_count    = var.ecs_service.desired_count
  platform_version = "1.3.0"
  launch_type      = "FARGATE"
  cluster          = aws_ecs_cluster.container.arn
  task_definition  = aws_ecs_task_definition.container.arn
  name             = var.ecs_service.name

  # Distribute traffic via an AWS ALB (Application Load Balancer)
  load_balancer {
    container_port   = var.ecs_service.container_port
    container_name   = var.ecs_service.container_name
    target_group_arn = var.ecs_service.target_group_arn
  }

  # Automatically assigns a public IP to our running tasks
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.container.id]
    subnets          = var.ecs_service.public_subnet_ids
  }

  # Due to autoscaling, the number of running instances may change so we want to ignore it in TF
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_count"]
  }

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

resource "aws_security_group" "container" {
  vpc_id = var.vpc_id

  # HTTPS
  ingress {
    protocol        = "tcp"
    from_port       = var.container_security_group.from_port
    to_port         = var.container_security_group.to_port
    security_groups = [var.container_security_group.load_balancer_security_group_id]
  }

  # Enable all outgoing
  egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

resource "aws_ecs_task_definition" "container" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_definition.cpu
  memory                   = var.ecs_task_definition.memory
  family                   = var.ecs_task_definition.family
  task_role_arn            = var.ecs_task_definition.task_role_arn
  execution_role_arn       = var.ecs_task_definition.execution_role_arn
  container_definitions    = module.container_definition.json

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# Container Definition
# Outputs the JSON necessary for configuring an ECS container
module "container_definition" {
  source          = "./container_definition/"
  container_name  = var.container_definition.container_name
  container_image = var.container_definition.container_image

  port_mappings = [{
    protocol      = "tcp"
    containerPort = var.container_definition.container_port
    hostPort      = var.container_definition.host_port
  }]

  log_options = {
    awslogs-stream-prefix = "ecs"
    awslogs-region        = var.container_definition.awslogs_region
    awslogs-group         = var.container_definition.awslogs_group
  }

  environment = [
    {
      name  = "NODE_ENV"
      value = var.container_definition_env.NODE_ENV
    },
    {
      name  = "REDIS_HOST"
      value = var.container_definition_env.REDIS_HOST
    },
    {
      name  = "REDIS_PORT"
      value = var.container_definition_env.REDIS_PORT
    },
    {
      name  = "DB_NAME"
      value = var.container_definition_env.DB_NAME
    },
    {
      name  = "DB_HOST"
      value = var.container_definition_env.DB_HOST
    },
    {
      name  = "DB_PORT"
      value = var.container_definition_env.DB_PORT
    },
    {
      name  = "CARDANO_IMPORTER_URL"
      value = var.container_definition_env.CARDANO_IMPORTER_URL
    },
    {
      name  = "CARDANO_BACKEND_URL"
      value = var.container_definition_env.CARDANO_BACKEND_URL
    },
    {
      name  = "DASHBOARD_SERVER_URL"
      value = var.container_definition_env.DASHBOARD_SERVER_URL
    },
    {
      name  = "SENTRY_DSN"
      value = var.container_definition_env.SENTRY_DSN
    },
    {
      name  = "SENTRY_ENVIRONMENT"
      value = var.container_definition_env.SENTRY_ENVIRONMENT
    },
  ]

  secrets = [
    {
      name      = "DB_USER"
      valueFrom = var.container_definition_env.DB_USER_SSM_ARN
    },
    {
      name      = "DB_PASS"
      valueFrom = var.container_definition_env.DB_PASS_SSM_ARN
    },
    {
      name      = "STRIPE_SECRET_KEY"
      valueFrom = var.container_definition_env.STRIPE_SECRET_KEY_SSM_ARN
    },
  ]
}
