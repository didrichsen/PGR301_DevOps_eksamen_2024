module "lambda_function" {
  source               = "./lambda_function"
  prefix               = var.prefix
  kandidat             = var.kandidat
  lambda_source_dir    = var.lambda_source_dir
  lambda_function_name = var.lambda_function_name
  bucket_name_ssm_parameter = var.bucket_name_ssm_parameter
}