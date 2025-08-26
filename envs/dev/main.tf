module "logging" {
  source      = "../../modules/logging"
  name_prefix = "amina"
  env         = var.env
  # leave CW Logs off for now; we’ll add later with one flag
  # enable_cloudwatch_logs = true
}

module "config" {
  source                  = "../../modules/config"
  name_prefix             = "baseline"

  conformance_pack_name   = "starter-dev"
  enable_conformance_pack = true

  tags = {
    Project = "tf-aws-secure-baseline"
    Env     = "dev"
    Step    = "3-config"
  }
}
