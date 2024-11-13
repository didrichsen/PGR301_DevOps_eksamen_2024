resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.prefix}_${var.kandidat}_lambda-function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_sqs.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = data.aws_ssm_parameter.bucket_name.value
    }
  }
}

data "archive_file" "lambda_zip" {
  source_file  = "${path.module}/lambda_sqs.py"
  type        = "zip"
  output_path = "${path.module}/lambda_code.zip"
}