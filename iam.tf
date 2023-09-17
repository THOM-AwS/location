resource "aws_iam_role" "cognito_ses_role" {
  name = "CognitoSESRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cognito-idp.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cognito_ses_send_email_attach" {
  role       = aws_iam_role.cognito_ses_role.name
  policy_arn = aws_iam_policy.cognito_ses_send_email.arn
}

resource "aws_iam_policy" "cognito_ses_send_email" {
  name        = "CognitoSESSendEmail"
  description = "Allows Amazon Cognito to send emails via SES"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "cognito_sms_role" {
  name = "Cognito_SMS_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Effect = "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy" "cognito_sms_permission" {
  name = "CognitoSMSSendPermission"
  role = aws_iam_role.cognito_sms_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
