# Request an ACM Certificate
resource "aws_acm_certificate" "subdomain" {
  domain_name       = "${var.subdomain_name}.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "domain" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "wildcard" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn         = aws_acm_certificate.subdomain.arn
  validation_record_fqdns = [for r in aws_route53_record.subdomain : r.fqdn]
}

resource "aws_acm_certificate_validation" "domain" {
  certificate_arn         = aws_acm_certificate.domain.arn
  validation_record_fqdns = [for r in aws_route53_record.domain : r.fqdn]
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for r in aws_route53_record.wildcard : r.fqdn]
}
