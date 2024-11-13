data "aws_ssm_parameter" "bucket_name" {
  name = "/image-generation/40/bucket-name"
}