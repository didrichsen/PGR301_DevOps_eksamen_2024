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

variable "aws_region" {
  description = "AWS region where the SQS queue is located"
  default     = "eu-west-1"
}

variable "threshold" {
  description = "Threshold for ApproximateAgeOfOldestMessage"
  type        = number
  default     = 5
}

variable "alarm_email" {
  description = "Email address to send notifications"
  type        = string
  default = "simendidrichsen@gmail.com"
}
