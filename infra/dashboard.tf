resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = local.dashboard_name
  dashboard_body = <<SQS_METRIC_DASHBOARD
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/SQS",
            "ApproximateAgeOfOldestMessage",
            "QueueName",
            "${module.lambda_function.sqs_queue_name}"
          ]
        ],
        "period": 10,
        "stat": "Maximum",
        "region": "${var.aws_region}",
        "title": "Approximate Age of Oldest Message"
      }
    }
  ]
}
SQS_METRIC_DASHBOARD
}
