variable "min_capacity" {
  type        = number
  description = "Minimum number of instances that must be active in the ECS cluster"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of instances that can be active in the ECS cluster"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecs_cluster_service_name" {
  type        = string
  description = "Name of the ECS cluster service"
}

variable "scale_up_policy_name" {
  type        = string
  description = "Name of the scaling up policy"
}

variable "scale_up_adjustment" {
  type        = number
  description = "Number of instances to add for a scaling up action"
  default     = 1
}

variable "scale_down_policy_name" {
  type        = string
  description = "Name of the scaling down policy"
}

variable "scale_down_adjustment" {
  type        = number
  description = "Number of instances to remove for a scaling down action"
  default     = -1
}
