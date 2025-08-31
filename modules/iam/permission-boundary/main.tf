
data "aws_iam_policy_document" "boundary" {
  # Block classic escalation stuff (defense-in-depth)
  statement {
    sid    = "DenyIamPrivilegeEscalation"
    effect = "Deny"
    actions = [
      "iam:CreateAccessKey",
      "iam:CreatePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:PutUserPolicy",
      "iam:PutRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  # Enforce SSE-KMS on S3 PutObject (same logic as SCP, but at principal level)
  statement {
    sid       = "DenyPutObjectWithoutSSEHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::*/*"]

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
    resources = ["arn:aws:s3:::*/*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  dynamic "statement" {
    for_each = length(var.allowed_kms_key_arns) > 0 ? [1] : []
    content {
      sid       = "DenyPutObjectIfWrongKMSKey"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["arn:aws:s3:::*/*"]

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

resource "aws_iam_policy" "boundary" {
  name   = var.name
  path   = var.path
  policy = data.aws_iam_policy_document.boundary.json
}

output "permissions_boundary_arn" {
  value = aws_iam_policy.boundary.arn
}
