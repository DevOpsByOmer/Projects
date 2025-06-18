resource "aws_acm_certificate" "app" {
  domain_name       = "devopsportfolio.live"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


