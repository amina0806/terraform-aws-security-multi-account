
# ------------------ Data ------------------
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  region    = data.aws_region.current.name
  partition = data.aws_partition.current.partition

  standards = {
    cis = {
      enabled = var.enable_security_hub && var.enable_security_hub_cis
      arn     = "arn:${local.partition}:securityhub:${local.region}::standards/cis-aws-foundations-benchmark/v/${var.cis_version}"
    }
    afsbp = {
      enabled = var.enable_security_hub && var.enable_security_hub_afsbp
      arn     = "arn:${local.partition}:securityhub:${local.region}::standards/aws-foundational-security-best-practices/v/${var.afsbp_version}"
    }
    nist = {
      enabled = var.enable_security_hub && var.enable_security_hub_nist
      # If you want NIST 800-53 rev 5, uncomment/set the correct ARN for your region/version
      # Check the exact ARN/version for your region if you enable this
      arn = "arn:${local.partition}:securityhub:${local.region}::standards/nist-800-53/v/5.0.0"
    }
  }
}

# ------------------ Security Hub ------------------
resource "aws_securityhub_account" "this" {
  count = var.enable_security_hub ? 1 : 0
}

# Subscribe to selected standards
resource "aws_securityhub_standards_subscription" "this" {
  for_each = {
    for k, v in local.standards : k => v
    if v.enabled
  }

  standards_arn = each.value.arn

  depends_on = [aws_securityhub_account.this]
}

# ------------------ GuardDuty ------------------
resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = var.enable_guardduty
  tags   = var.tags

  datasources {
    s3_logs {
      enable = var.gd_enable_s3_protection
    }

    kubernetes {
      audit_logs {
        enable = var.gd_enable_eks_audit_logs
      }
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.gd_enable_malware_protection_ebs
        }
      }
    }
  }
}
