resource "aws_dynamodb_table" "table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key
    type = var.dynamodb_hash_key_type
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb.arn
  }

  tags = var.tags
}

resource "aws_kms_key" "dynamodb" {
  description             = "KMS key for DynamoDB server-side encryption"
  deletion_window_in_days = 7
}

