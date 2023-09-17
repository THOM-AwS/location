resource "aws_acm_certificate" "wildcard" { // Cert for *.apse2.com.au
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cognito_cert_validation" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [aws_route53_record.validate_wildcard.fqdn]
  depends_on              = [aws_route53_record.validate_wildcard]
}
