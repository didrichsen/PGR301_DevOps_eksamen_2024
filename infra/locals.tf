locals {
  lambda_source_dir = var.lambda_source_dir != "" ? var.lambda_source_dir : path.root
}