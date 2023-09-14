resource "aws_ses_domain_identity" "apse2_domain" {
  domain = "apse2.com.au"
}

resource "aws_ses_email_identity" "noreply" {
  email = "noreply@apse2.com.au"
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain     = aws_ses_domain_identity.apse2_domain.id
  depends_on = [aws_route53_record.apse2_domain_verification]
}