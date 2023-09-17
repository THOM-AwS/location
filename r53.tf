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
  name    = tolist(aws_acm_certificate.wildcard.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.wildcard.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  records = [tolist(aws_acm_certificate.wildcard.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cognito_a_record" {
  name    = aws_cognito_user_pool_domain.cognito_domain.domain
  type    = "A"
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.cognito_domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.cognito_domain.cloudfront_distribution_zone_id
  }
}

// needed for cognito domain
resource "aws_acm_certificate" "location_subdomain" {
  domain_name       = "*.${var.subdomain_name}.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

// needed for cognito domain
resource "aws_route53_record" "validate_location_subdomain" {
  name    = tolist(aws_acm_certificate.location_subdomain.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.location_subdomain.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  records = [tolist(aws_acm_certificate.location_subdomain.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "root_domain" { // temp work around for root domain a record.
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = ["3.104.111.19"]
}
