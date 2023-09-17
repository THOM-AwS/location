# Fetch Route53 Zone Details
data "aws_route53_zone" "apse2_domain" {
  name = var.domain_name
}

# SES Domain Verification Record
resource "aws_route53_record" "apse2_domain_verification" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.apse2_domain.id}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

# Alias Record for Cloudfront Distribution
resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

// Cert validation for cognito
resource "aws_route53_record" "validate_wildcard" {
  name    = aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  records = [aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
