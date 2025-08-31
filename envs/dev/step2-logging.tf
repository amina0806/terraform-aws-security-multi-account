module "logging" {
  source = "../../modules/logging"

  name_prefix = local.name_prefix
  env         = var.env

  enable_cloudtrail = false
  tags              = local.tags
}
