output "scale_up_policy_arn" {
  value = "${aws_appautoscaling_policy.scale_up.arn}"
}

output "scale_down_policy_arn" {
  value = "${aws_appautoscaling_policy.scale_down.arn}"
}
