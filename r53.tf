data "aws_route53_zone" "apse2_domain" {
  name = var.domain_name
}

resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "${aws_ses_domain_identity.apse2_domain.verification_token}._domainkey.${var.domain_name}"
  type    = "TXT"
  ttl     = "3600"
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.apse2_domain.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"
  ttl     = "300"

  alias {
    name                   = "YOUR_CLOUDFRONT_OR_ELBS_URL"     # Replace with your actual endpoint URL.
    zone_id                = "YOUR_CLOUDFRONT_OR_ELBS_ZONE_ID" # Replace with the corresponding Zone ID.
    evaluate_target_health = false
  }
}