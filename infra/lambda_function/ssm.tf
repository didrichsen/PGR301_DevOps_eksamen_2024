data "aws_ssm_parameter" "bucket_name" {
  name = var.bucket_name_ssm_parameter
}