resource "aws_sqs_queue" "lambda_queue" {
  name = "${var.prefix}_${var.kandidat}_lambda_queue"
  visibility_timeout_seconds = 60
}

resource "aws_lambda_event_source_mapping" "lambda_sqs_trigger" {
  event_source_arn = aws_sqs_queue.lambda_queue.arn
  function_name    = aws_lambda_function.lambda_function.arn
  enabled          = true
}

output "sqs_queue_name" {
  value = aws_sqs_queue.lambda_queue.name
}