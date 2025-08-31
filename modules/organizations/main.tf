
data "aws_caller_identity" "current" {}

resource "aws_organizations_organizational_unit" "ou" {
  for_each  = { for name in var.ou_names : name => name }
  name      = each.key
  parent_id = local.root_id
}

locals {
  scp_deny_leave_org = {
    Version = "2012-10-17"
    Statement = [{
      Sid      = "DenyLeaveOrganization"
      Effect   = "Deny"
      Action   = ["organizations:LeaveOrganization"]
      Resource = "*"
    }]
  }

  scp_protect_security_services = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDisableCloudTrail"
        Effect = "Deny"
        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail",
          "cloudtrail:UpdateTrail",
          "cloudtrail:PutEventSelectors",
          "cloudtrail:PutInsightSelectors"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyDisableConfig"
        Effect = "Deny"
        Action = [
          "config:StopConfigurationRecorder",
          "config:DeleteConfigurationRecorder",
          "config:DeleteDeliveryChannel"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyDisableGuardDuty"
        Effect = "Deny"
        Action = [
          "guardduty:DeleteDetector",
          "guardduty:UpdateDetector"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyDisableSecurityHub"
        Effect = "Deny"
        Action = [
          "securityhub:DisableSecurityHub"
        ]
        Resource = "*"
      }
    ]
  }

  scp_restrict_regions = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyNonApprovedRegions"
        Effect = "Deny"
        NotAction = [
          "account:*",
          "cloudfront:*",
          "globalaccelerator:*",
          "iam:*",
          "organizations:*",
          "route53:*",
          "support:*",
          "waf:*",
          "wafv2:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = var.allowed_regions
          }
        }
      }
    ]
  }

  scp_require_mfa_iam = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyIAMWriteWithoutMFA"
        Effect = "Deny"
        Action = [
          "iam:Create*",
          "iam:Delete*",
          "iam:Update*",
          "iam:Attach*",
          "iam:Put*",
          "iam:Add*",
          "iam:Remove*",
          "iam:Set*",
          "iam:ChangePassword"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  }

  scp_deny_root_user = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyAllForRootUser",
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  }


  policy_defs = {
    DenyLeaveOrg            = local.scp_deny_leave_org
    ProtectSecurityServices = var.enable_protect_security_services ? local.scp_protect_security_services : null
    RestrictRegions         = length(var.allowed_regions) > 0 ? local.scp_restrict_regions : null
    RequireMFAForIAM        = var.enable_require_mfa_iam ? local.scp_require_mfa_iam : null
    DenyRootUser            = var.enable_deny_root_user ? local.scp_deny_root_user : null
  }
}


resource "aws_organizations_policy" "this" {
  for_each    = { for k, v in local.policy_defs : k => v if v != null }
  name        = each.key
  description = "SCP: ${each.key}"
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode(each.value)
}

resource "aws_organizations_policy_attachment" "root" {
  for_each  = var.attach_to_root ? aws_organizations_policy.this : {}
  policy_id = each.value.id
  target_id = local.root_id
}

resource "aws_organizations_policy_attachment" "ou" {
  for_each = var.attach_to_ous ? {
    for combo in setproduct(keys(aws_organizations_policy.this), keys(aws_organizations_organizational_unit.ou)) :
    "${combo[0]}.${combo[1]}" => {
      policy_id = aws_organizations_policy.this[combo[0]].id
      target_id = aws_organizations_organizational_unit.ou[combo[1]].id
    }
  } : {}
  policy_id = each.value.policy_id
  target_id = each.value.target_id
}
