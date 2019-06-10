variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "scale_up_metric_alarm" {
  type        = map(string)
  description = "Monitors our ECS instances and performs a scale up action when the parameters are met. Accepts these props: alarm_name, metric_name, threshold, alarm_action"
}

variable "scale_down_metric_alarm" {
  type        = map(string)
  description = "Monitors our ECS instances and performs a scale down action when the parameters are met. Accepts these props: name, metric_name, threshold"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags. Accepts the following props: Name, Environment, Description"
}
