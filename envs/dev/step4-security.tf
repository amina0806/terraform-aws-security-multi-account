module "security_services" {
  source = "../../modules/security-services"

  name_prefix = local.name_prefix
  tags        = local.tags

  # ---- Security Hub ----
  enable_security_hub     = var.enable_security_hub
  enable_security_hub_cis = true
  cis_version             = "1.4.0"

  enable_security_hub_afsbp = true
  afsbp_version             = "1.0.0"

  enable_security_hub_nist = true

  # ---- GuardDuty ----
  enable_guardduty                 = var.enable_guardduty
  gd_enable_s3_protection          = true
  gd_enable_eks_audit_logs         = false
  gd_enable_malware_protection_ebs = true
}
