variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "kandidat" {
  description = "Kandidatnummer eksamen devops 2024"
  type        = string
}

variable "lambda_source_dir" {
  description = "Path to the directory containing the Lambda function code"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my_lambda_function"
}
