resource "aws_iam_role" "lambda_exec_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })

  name = "${var.prefix}_${var.kandidat}_lambda_exec_role"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name = "${var.prefix}_${var.kandidat}_lambda_sqs_policy"
  role = aws_iam_role.lambda_exec_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.lambda_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_bedrock_policy" {
  name = "${var.prefix}_${var.kandidat}_lambda_bedrock_policy"
  role = aws_iam_role.lambda_exec_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:InvokeModel"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "${var.prefix}_${var.kandidat}_lambda_s3_policy"
  role = aws_iam_role.lambda_exec_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${data.aws_ssm_parameter.bucket_name.value}/40/images/*"
      }
    ]
  })
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "lambda_ssm_policy" {
  name = "${var.prefix}_${var.kandidat}_lambda_ssm_policy"
  role = aws_iam_role.lambda_exec_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/image-generation/40/bucket-name"
      }
    ]
  })
}