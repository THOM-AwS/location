# Request an ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.subdomain_name}.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "cert_base" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
