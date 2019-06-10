output "target_group_arn" {
  value = aws_lb_target_group.load_balancer.arn
}

output "security_group_id" {
  value = module.security_group.id
}

output "zone_id" {
  value = aws_lb.load_balancer.zone_id
}

output "dns_name" {
  value = aws_lb.load_balancer.dns_name
}

