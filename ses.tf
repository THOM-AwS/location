resource "aws_ses_domain_identity" "apse2_domain" {
  domain = "apse2.com.au"
}

resource "aws_route53_record" "apse2_domain_verification" {
  zone_id = "YOUR_ROUTE53_ZONE_ID_FOR_APSE2" # You need to get this from your Route53 hosted zone
  name    = "${aws_ses_domain_identity.apse2_domain.verification_token}._domainkey.apse2.com.au"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

resource "aws_ses_email_identity" "noreply" {
  email = "noreply@apse2.com.au"
}
