# Request an ACM Certificate
# resource "aws_acm_certificate" "subdomain" { // Cert for location.apse2.com.au
#   domain_name       = "${var.subdomain_name}.${var.domain_name}"
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate" "domain" { // Cert for apse2.com.au
#   domain_name       = var.domain_name
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_acm_certificate" "wildcard" { // Cert for *.apse2.com.au
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cognito_cert_validation" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [aws_route53_record.wildcard.fqdn]
}


