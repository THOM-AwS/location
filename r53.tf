data "aws_route53_zone" "apse2_domain" {
  name = var.domain_name
}

resource "aws_route53_record" "apse2_domain_verification" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id # You need to get this from your Route53 hosted zone
  name    = "_amazonses.${aws_ses_domain_identity.apse2_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.web.website_endpoint
    zone_id                = "Z3AQBSTGFYJSTF"
    evaluate_target_health = false
  }
}

# DNS record for ACM certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation" {
  zone_id = var.route53_zone_id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

# Certificate validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
