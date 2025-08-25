module "logging" {
  source      = "../../modules/logging"
  name_prefix = "amina"
  env         = var.env
  # leave CW Logs off for now; we’ll add later with one flag
  # enable_cloudwatch_logs = true
}
