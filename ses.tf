resource "aws_ses_domain_identity" "apse2_domain" {
  domain = "apse2.com.au"
}

resource "aws_route53_record" "apse2_domain_verification" {
  zone_id = "Z012116528BBKQBWO9WHV" # You need to get this from your Route53 hosted zone
  name    = "_amazonses.${aws_ses_domain_identity.apse2_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.apse2_domain.verification_token]
}

resource "aws_ses_email_identity" "noreply" {
  email = "noreply@apse2.com.au"
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain     = aws_ses_domain_identity.apse2_domain.id
  depends_on = [aws_route53_record.apse2_domain_verification]
}