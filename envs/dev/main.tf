locals {
  name_prefix = "amina-dev"
  tags = {
    Project = "tf-aws-secure-baseline"
    Env     = "dev"
    Owner   = "amina"
  }
}

module "logging" {
  source      = "../../modules/logging"
  name_prefix = "amina"
  env         = var.env
  # leave CW Logs off for now; we’ll add later with one flag
  # enable_cloudwatch_logs = true
}

module "config" {
  source      = "../../modules/config"
  name_prefix = "baseline"

  conformance_pack_name   = "starter-dev"
  enable_conformance_pack = true

  tags = {
    Project = "tf-aws-secure-baseline"
    Env     = "dev"
    Step    = "3-config"
  }
}

module "security_services" {
  source = "../../modules/security-services"

  name_prefix = local.name_prefix
  tags        = local.tags

  # ---- Security Hub ----
  enable_security_hub     = true
  enable_security_hub_cis = true
  cis_version             = "1.4.0"

  enable_security_hub_afsbp = true
  afsbp_version             = "1.0.0"

  enable_security_hub_nist = true # set true only after checking ARN/version for your region

  # ---- GuardDuty ----
  enable_guardduty                 = true
  gd_enable_s3_protection          = true
  gd_enable_eks_audit_logs         = false
  gd_enable_malware_protection_ebs = true
}
