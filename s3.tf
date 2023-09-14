resource "aws_s3_bucket" "web_content" {
  bucket = "${var.subdomain_name}-${var.domain_name}"
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "web_content_policy" {
  bucket = aws_s3_bucket.web_content.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_content.bucket}/*"
      }
    ]
  })
}
