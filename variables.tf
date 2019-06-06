variable "route53_record" {
  type        = list(map(string))
  description = "Records allow us to manage how traffic to our domain is routed. Accepts these props: type, name, alias_evaluate_target_health, alias_zone_id, alias_name"
}
