output "user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.api.id
}

output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}