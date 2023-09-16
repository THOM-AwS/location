resource "aws_s3_bucket" "web_content" {
  bucket = "${var.subdomain_name}.${var.domain_name}"
}

resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web_content.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
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
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_content.bucket}/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::941133421128:user/actions"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.web_content.bucket}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "acl" {
  bucket = aws_s3_bucket.web_content.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket                  = aws_s3_bucket.web_content.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
