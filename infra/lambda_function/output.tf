output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.lambda_queue.url
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda_function.function_name
}