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
    name                   = aws_s3_bucket.web_content.website_endpoint # Replace with your actual endpoint URL.
    zone_id                = "Z3AQBSTGFYJSTF"                           # Replace with the corresponding Zone ID.
    evaluate_target_health = false
  }
}
