variable "ecs_cluster_name" {
  type        = string
  description = "Name of ECS cluster"
}

variable "ecs_service" {
  type        = map(string)
  description = "ECS service which manages task container instances. Accepts the following props: desired_count, name, container_port, container_name, target_group_arn, public_subnet_ids"
}

variable "container_security_group" {
  type        = map(string)
  description = "Security group of the ECS service which manages task container instances. Accepts the following props: from_port, to_port, load_balancer_security_group_id"
}

variable "ecs_task_definition" {
  type        = map(string)
  description = "ECS task definitions are the VMs which our containers are executed on. Accepts the following props: cpu, memory, family, task_role_arn, execution_role_arn"
}

variable "container_definition" {
  type        = map(string)
  description = "Container definitions are mappings to our Docker images. Accepts the following props: container_name, container_image, container_port, host_port, awslogs_region, awslogs_group"
}

variable "container_definition_env" {
  type        = map(string)
  description = "Environment variables that our application needs in order to function. Accepts the following props: NODE_ENV, REDIS_HOST, REDIS_PORT, DB_NAME, DB_HOST, DB_PORT, CARDANO_IMPORTER_URL, CARDANO_BACKEND_URL, DASHBOARD_SERVER_URL, SENTRY_DSN, SENTRY_ENVIRONMENT, DB_USER_SSM_ARN, DB_PASS_SSM_ARN, STRIPE_SECRET_KEY_SSM_ARN"
}

variable "resource_name_tag" {
  type        = string
  description = "Name of ECS cluster"
}

variable "resource_environment_tag" {
  type        = string
  description = "Name of ECS cluster"
}
