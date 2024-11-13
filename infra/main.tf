module "lambda_function" {
  source               = "./lambda_function"  # Path to your lambda_function module
  prefix               = var.prefix
  kandidat             = var.kandidat
  lambda_source_dir    = var.lambda_source_dir
  lambda_function_name = var.lambda_function_name
}