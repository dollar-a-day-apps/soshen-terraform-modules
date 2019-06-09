variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of ECS cluster"
}

variable "ecs_service" {
  type        = map(string)
  description = "ECS service which manages task container instances. Accepts the following props: desired_count, name, container_port, container_name, target_group_arn"
}

variable "container_security_group" {
  type        = map(string)
  description = "Security group of the ECS service which manages task container instances. Accepts the following props: ingress_from_port, ingress_to_port, ingress_security_group_id"
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
  type        = list(map(string))
  description = "Environment variables that our application needs in order to function."
}

variable "container_definition_secrets" {
  type        = list(map(string))
  description = "Sensitive environment variables that our application needs in order to function. Values should be SSM ARNs"
}

variable "resource_name_tag" {
  type        = string
  description = "Name of ECS cluster"
}

variable "resource_environment_tag" {
  type        = string
  description = "Name of ECS cluster"
}
