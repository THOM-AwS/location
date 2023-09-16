// === Cognito User Pool Configuration ===
resource "aws_cognito_user_pool" "location_user_pool" {
  name = "location_apse2_user_pool"
  // Verification and Aliases
  auto_verified_attributes = ["email"]
  alias_attributes         = ["email"]

  // SMS and MFA
  mfa_configuration          = "OFF"
  sms_authentication_message = "Your authentication code is {####}"
  sms_verification_message   = "Your verification code is {####}"

  // Password Policy
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 1
  }

  // Email Configuration
  # email_configuration {
  #   reply_to_email_address = aws_ses_email_identity.noreply.email
  #   source_arn             = aws_ses_email_identity.noreply.arn
  #   email_sending_account  = "DEVELOPER"
  # }

  # Other configurations...
}

// === Cognito User Pool Client Configuration ===
resource "aws_cognito_user_pool_client" "location_user_pool_client" {
  name         = "location_apse2_user_pool_client"
  user_pool_id = aws_cognito_user_pool.location_user_pool.id

  // OAuth and Scopes
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

  // URLs
  callback_urls = [
    "https://location.apse2.com.au/callback",
    "https://location.apse2.com.au/home"
  ]
  logout_urls          = ["https://location.apse2.com.au/logout"]
  default_redirect_uri = "https://location.apse2.com.au/home"

  // Identity Providers
  supported_identity_providers = ["COGNITO"]

  // Secrets
  generate_secret = false

  # Additional client configurations...
}

resource "aws_cognito_user_pool_domain" "example" {
  domain          = var.domain_name
  user_pool_id    = aws_cognito_user_pool.location_user_pool.id
  certificate_arn = aws_acm_certificate.cert.arn
}
