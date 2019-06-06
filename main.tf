data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket = "soshen.terraform.state"
    key    = "foundation.terraform.tfstate"
    region = "us-east-1"
  }
}

# Get the data for the existing soshen.io Route 53 host zone
data "aws_route53_zone" "soshen" {
  private_zone = false
  zone_id      = data.terraform_remote_state.foundation.outputs.route53_zone_id
}

# Allows us to create records (rules) for routing domain traffic
resource "aws_route53_record" "soshen" {
  count   = length(var.route53_records)
  zone_id = data.aws_route53_zone.soshen.host_id
  type    = var.route53_records[count.index].type
  name    = var.route53_records[count.index].name

  alias {
    # Not all resources can support this
    evaluate_target_health = var.route53_records[count.index].alias_evaluate_target_health

    # Details for an AWS resource that can be aliased
    # For example, having all nodes.soshen.io requests go to the soshen-node-server load balancer
    zone_id = var.route53_records[count.index].alias_zone_id
    name    = var.route53_records[count.index].alias_name
  }
}
