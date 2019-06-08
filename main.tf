# Monitoring
# Monitors our containers' CPU utilization and performs actions when the thresholds are breached

# Stores and manages CloudWatch logs
resource "aws_cloudwatch_log_group" "log_group" {
  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

# A CloudWatch Alarm configuration
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = var.scale_up_metric_alarm.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = var.scale_up_metric_alarm.metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  threshold           = var.scale_up_metric_alarm.threshold
  evaluation_periods  = 1
  period              = 300

  # Specifies what instance we are applying the alarm config to
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  # Provisions a new ECS task instance when above parameters are met
  alarm_actions = [var.scale_up_metric_alarm.alarm_action]

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = var.scale_down_metric_alarm.alarm_name
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = var.scale_down_metric_alarm.metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  threshold           = var.scale_down_metric_alarm.threshold
  evaluation_periods  = 1
  period              = 300

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  # Derovisions a new ECS task instance when above parameters are met
  alarm_actions = [var.scale_down_metric_alarm.alarm_action]

  tags = {
    Name        = var.resource_name_tag
    Environment = var.resource_environment_tag
  }
}
