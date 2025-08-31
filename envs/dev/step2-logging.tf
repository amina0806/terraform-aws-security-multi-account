module "logging" {
  source = "../../modules/logging"

  name_prefix = local.name_prefix
  env         = var.env

  # enable_cloudwatch_logs = true

  tags = local.tags
}
