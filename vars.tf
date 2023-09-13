// === AWS Configuration ===
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  default     = "us-east-1"
  type        = string
}

// === Domain and Route53 Configuration ===
variable "domain_name" {
  description = "Main domain name."
  default     = "apse2.com.au"
  type        = string
}

variable "subdomain_name" {
  description = "Subdomain name for the application."
  default     = "location"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the domain."
  type        = string
}

// === Email Configuration ===
variable "reply_email" {
  description = "Reply-to email address for Cognito emails."
  default     = "noreply@apse2.com.au"
  type        = string
}

// === Cognito User Pool Configuration ===
variable "cognito_pool_name" {
  description = "Name for the Cognito user pool."
  default     = "user_pool"
  type        = string
}

variable "cognito_client_name" {
  description = "Name for the Cognito user pool client."
  default     = "user_pool_client"
  type        = string
}

// === Cognito OAuth URLs ===
variable "cognito_callback_url" {
  description = "Callback URL for Cognito OAuth 2.0."
  default     = "https://location.apse2.com.au/callback"
  type        = string
}

variable "cognito_logout_url" {
  description = "Logout URL for Cognito OAuth 2.0."
  default     = "https://location.apse2.com.au/logout"
  type        = string
}

variable "cognito_default_redirect_url" {
  description = "Default redirect URL for Cognito OAuth 2.0."
  default     = "https://location.apse2.com.au/home"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table."
  default     = "Table"
  type        = string
}

variable "dynamodb_read_capacity" {
  description = "Read capacity units for the DynamoDB table."
  default     = 5
  type        = number
}

variable "dynamodb_write_capacity" {
  description = "Write capacity units for the DynamoDB table."
  default     = 5
  type        = number
}

variable "dynamodb_hash_key" {
  description = "The attribute to use as the hash key."
  default     = "id"
  type        = string
}

variable "dynamodb_hash_key_type" {
  description = "The data type for the hash key."
  default     = "S"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the DynamoDB table."
  default = {
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
  type = map(string)
}
