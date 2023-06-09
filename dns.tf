# --------------------------
# Route53
# --------------------------
# zone(本体)作成
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false

  tags = {
    Name    = "${var.project}-${var.environment}-domain"
    Project = var.project
    Env     = var.environment
  }
}

# record設定(Aレコード)
resource "aws_route53_record" "aws_route53_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "dev-elb.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}