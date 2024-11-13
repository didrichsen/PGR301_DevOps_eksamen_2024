variable "kandidat" {
  description = "Kandidatnummer eksamen devops 2024"
  type = string
  default = "40"
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "DevOpsEksamen2024-"
}

variable "lambda_source_dir" {
  description = "Path to the directory containing the Lambda function code"
  type        = string
  default = ""
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my_lambda_function"
}
