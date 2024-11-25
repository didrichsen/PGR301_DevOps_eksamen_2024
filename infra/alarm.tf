resource "aws_cloudwatch_metric_alarm" "sqs_age_alarm" {
  alarm_name  = "${var.prefix}${var.kandidat}-sqs-age-alarm"
  namespace   = "AWS/SQS"
  metric_name = "ApproximateAgeOfOldestMessage"
  dimensions = {
    QueueName = module.lambda_function.sqs_queue_name
  }

  comparison_operator = "GreaterThanThreshold"
  threshold = var.threshold
  evaluation_periods = 1
  period = 60
  statistic = "Maximum"
  alarm_description   = "This alarm triggers when the ApproximateAgeOfOldestMessage for the SQS queue exceeds the threshold"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_sns_topic" "user_updates" {
  name = "${var.prefix}${var.kandidat}-sqs-alarm-topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}