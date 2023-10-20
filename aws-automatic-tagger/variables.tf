variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

variable "create_trail" {
  description = "Set to false if a Cloudtrail trail for management events exists"
  type        = bool
  default     = true
}

variable "autotag_function_name" {
  description = "Name of Lambda function"
  type        = string
  default     = "autotag"
}

variable "lambda_log_level" {
  description = "Lambda logging level"
  type        = string
  default     = "INFO"
}