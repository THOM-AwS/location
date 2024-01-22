# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/function_code" # Directory containing your Lambda function
#   output_path = "${path.module}/lambda_function_payload.zip"
# }

# resource "aws_lambda_function" "ddb_query" {
#   filename         = data.archive_file.lambda_zip.output_path
#   function_name    = "ddb_query_function"
#   role             = aws_iam_role.lambda_execution_role.arn
#   handler          = "index.handler" # Ensure that your Lambda's entry point is index.handler
#   runtime          = "nodejs14.x"
#   description      = "Lambda function to query DynamoDB table."
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256

#   environment {
#     variables = {
#       DYNAMODB_TABLE = aws_dynamodb_table.table.name
#     }
#   }
# }

# resource "aws_iam_role" "lambda_execution_role" {
#   name = "role_lambda_ddb_query"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         },
#         Effect = "Allow",
#         Sid    = "LambdaAssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "lambda_execution_policy" {
#   name = "policy_lambda_ddb_query"
#   role = aws_iam_role.lambda_execution_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = ["dynamodb:Query"],
#         Resource = aws_dynamodb_table.table.arn
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/${aws_lambda_function.ddb_query.function_name}:*"
#       }
#     ]
#   })
# }
