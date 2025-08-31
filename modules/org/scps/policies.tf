# Deny if SSE header is missing or not aws:kms
data "aws_iam_policy_document" "scp_deny_putobject_no_kms" {
  statement {
    sid       = "DenyPutObjectWithoutSSEHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"] # SCP requires "*"

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }

  statement {
    sid       = "DenyPutObjectIfNotKMS"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"] # SCP requires "*"

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }
}

# Optional: only allow specific KMS key ids
data "aws_iam_policy_document" "scp_enforce_specific_kms" {
  dynamic "statement" {
    for_each = length(var.allowed_kms_key_arns) > 0 ? [1] : []
    content {
      sid       = "DenyPutObjectWithWrongKMSKey"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["*"] # SCP requires "*"

      condition {
        test     = "Null"
        variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
        values   = ["true"]
      }

      condition {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
        values   = var.allowed_kms_key_arns
      }
    }
  }
}

# Optional: protect CloudTrail
data "aws_iam_policy_document" "scp_protect_cloudtrail" {
  statement {
    sid    = "DenyDisablingOrDeletingCloudTrail"
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
      "cloudtrail:PutEventSelectors"
    ]
    resources = ["*"] # SCP requires "*"
  }
}
resource "aws_organizations_policy" "deny_putobject_no_kms" {
  name        = "DenyS3PutObjectWithoutKMS"
  description = "Blocks s3:PutObject if SSE header missing or not aws:kms."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.scp_deny_putobject_no_kms.json
}

resource "aws_organizations_policy" "enforce_specific_kms" {
  count       = length(var.allowed_kms_key_arns) > 0 ? 1 : 0
  name        = "EnforceSpecificKmsKeyForS3PutObject"
  description = "Blocks s3:PutObject unless using one of the allowed KMS keys."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.scp_enforce_specific_kms.json
}

resource "aws_organizations_policy" "protect_cloudtrail" {
  count       = var.enable_cloudtrail_protection ? 1 : 0
  name        = "ProtectCloudTrail"
  description = "Prevents disabling or deleting CloudTrail."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.scp_protect_cloudtrail.json
}

# Attach to Root
resource "aws_organizations_policy_attachment" "root_deny_putobject_no_kms" {
  policy_id = aws_organizations_policy.deny_putobject_no_kms.id
  target_id = var.root_id
}

resource "aws_organizations_policy_attachment" "root_enforce_specific_kms" {
  count     = length(var.allowed_kms_key_arns) > 0 ? 1 : 0
  policy_id = aws_organizations_policy.enforce_specific_kms[0].id
  target_id = var.root_id
}

resource "aws_organizations_policy_attachment" "root_protect_cloudtrail" {
  count     = var.enable_cloudtrail_protection ? 1 : 0
  policy_id = aws_organizations_policy.protect_cloudtrail[0].id
  target_id = var.root_id
}

# attach to selected OUs
resource "aws_organizations_policy_attachment" "ou_deny_putobject_no_kms" {
  for_each  = toset(var.target_ou_ids)
  policy_id = aws_organizations_policy.deny_putobject_no_kms.id
  target_id = each.value
}

resource "aws_organizations_policy_attachment" "ou_enforce_specific_kms" {
  for_each  = length(var.allowed_kms_key_arns) > 0 ? toset(var.target_ou_ids) : []
  policy_id = aws_organizations_policy.enforce_specific_kms[0].id
  target_id = each.value
}

resource "aws_organizations_policy_attachment" "ou_protect_cloudtrail" {
  for_each  = var.enable_cloudtrail_protection ? toset(var.target_ou_ids) : []
  policy_id = aws_organizations_policy.protect_cloudtrail[0].id
  target_id = each.value
}

# attach to specific accounts
resource "aws_organizations_policy_attachment" "acct_deny_putobject_no_kms" {
  for_each  = toset(var.target_account_ids)
  policy_id = aws_organizations_policy.deny_putobject_no_kms.id
  target_id = each.value
}

resource "aws_organizations_policy_attachment" "acct_enforce_specific_kms" {
  for_each  = length(var.allowed_kms_key_arns) > 0 ? toset(var.target_account_ids) : []
  policy_id = aws_organizations_policy.enforce_specific_kms[0].id
  target_id = each.value
}

resource "aws_organizations_policy_attachment" "acct_protect_cloudtrail" {
  for_each  = var.enable_cloudtrail_protection ? toset(var.target_account_ids) : []
  policy_id = aws_organizations_policy.protect_cloudtrail[0].id
  target_id = each.value
}
