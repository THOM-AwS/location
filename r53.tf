# Fetch Route53 Zone Details
data "aws_route53_zone" "apse2_domain" {
  name = var.domain_name
}

# Create an A record alias pointing to the CloudFront distribution
# resource "aws_route53_record" "root_domain_a_record" {
#   zone_id = data.aws_route53_zone.apse2_domain.zone_id
#   name    = var.domain_name
#   type    = "A"
#   records = ["8.8.8.8"]
#   # alias {
#   #   name                   = aws_cloudfront_distribution.s3_distribution.domain_name
#   #   zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
#   #   evaluate_target_health = false
#   # }
# }
resource "aws_route53_record" "root_domain_a_record" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = var.domain_name # this should be set to apse2.com.au
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


# SES Domain Verification Record
resource "aws_route53_record" "apse2_domain_verification" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.apse2_domain.id}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

# Alias Record for Cognito User Pool Domain's Cloudfront Distribution
resource "aws_route53_record" "cognito" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.domain.cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}

# ACM Certificate Validation Record
resource "aws_route53_record" "subdomain" {
  for_each = {
    for dvo in aws_acm_certificate.subdomain.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

# ACM Certificate Validation Record
resource "aws_route53_record" "domain" {
  for_each = {
    for dvo in aws_acm_certificate.domain.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}


