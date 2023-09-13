// === API Gateway REST API ===
resource "aws_api_gateway_rest_api" "ddb_query_api" {
  name        = "ddb_query_api"
  description = "API Gateway for DynamoDB Query secured with Cognito"
}

// === API Gateway Resource (Endpoint) ===
resource "aws_api_gateway_resource" "query_endpoint" {
  rest_api_id = aws_api_gateway_rest_api.ddb_query_api.id
  parent_id   = aws_api_gateway_rest_api.ddb_query_api.root_resource_id
  path_part   = "query"
}

// === Cognito User Pool Authorizer for API Gateway ===
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito_authorizer_for_ddb_query"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.ddb_query_api.id
  provider_arns = [aws_cognito_user_pool.main.arn]
}

// === API Gateway Method (HTTP POST) ===
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.ddb_query_api.id
  resource_id   = aws_api_gateway_resource.query_endpoint.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

// === API Gateway Integration with Lambda ===
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.ddb_query_api.id
  resource_id = aws_api_gateway_resource.query_endpoint.id
  http_method = aws_api_gateway_method.post_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ddb_query.invoke_arn
}

// === Permission for API Gateway to Invoke Lambda ===
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ddb_query.function_name
  principal     = "apigateway.amazonaws.com"
}
