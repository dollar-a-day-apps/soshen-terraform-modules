# Autoscaling
# Provisions or deprovisions container instances
# Used in conjunction with CloudWatch's alarms

resource "aws_appautoscaling_target" "ecs" {
  min_capacity       = "${var.min_capacity}"
  max_capacity       = "${var.max_capacity}"
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.scale_up_policy_name}"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.ecs.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.ecs.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.ecs.service_namespace}"

  step_scaling_policy_configuration {
    cooldown                = 60
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0.0
      scaling_adjustment          = "${var.scale_up_adjustment}"
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${var.scale_down_policy_name}"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.ecs.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.ecs.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.ecs.service_namespace}"

  step_scaling_policy_configuration {
    cooldown                = 60
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0.0
      scaling_adjustment          = "${var.scale_down_adjustment}"
    }
  }
}
