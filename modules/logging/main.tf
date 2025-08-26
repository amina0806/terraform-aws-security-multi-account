# --- Data sources ---
data "aws_caller_identity" "current" {}
data "aws_region"          "current" {}
data "aws_partition"       "current" {}

# --- Locals (single block only) ---
locals {
  bucket_name = coalesce(
    var.log_bucket_name,
    format(
      "%s-logs-%s-%s",
      var.name_prefix,
      data.aws_caller_identity.current.account_id,
      data.aws_region.current.name
    )
  )

  name_base = coalesce(var.log_group_name_base, "${var.name_prefix}-${var.env}")

  kms_alias = coalesce(var.kms_alias, "alias/${var.name_prefix}-logging")
}


# ---------- KMS (CMK) for CloudTrail ----------
resource "aws_kms_key" "logging" {
  description         = "CMK for CloudTrail logs"
  enable_key_rotation = true

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowAccountRoot",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid      = "AllowCloudTrail",
        Effect   = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action   = [
          "kms:Encrypt",
          "kms:GenerateDataKey*","kms:DescribeKey","kms:CreateGrant"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          },
          ArnLike = {
            "aws:SourceArn" = "arn:${data.aws_partition.current.partition}:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "logging" {
  name          = local.kms_alias
  target_key_id = aws_kms_key.logging.key_id
}

# ------------------ S3 log bucket ------------------
resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.logging.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# TLS-only + enforce KMS for uploads
data "aws_iam_policy_document" "bucket_security" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals { 
      type = "*"
      identifiers = ["*"] 
    }
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.logs.arn}/*", aws_s3_bucket.logs.arn]
    condition { 
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"] 
    }
  }

  statement {
    sid    = "DenyUnencryptedUploads"
    effect = "Deny"
    principals { 
      type = "*"
      identifiers = ["*"] 
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    condition { 
      test = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values = ["aws:kms"] 
    }
  }

  statement {
    sid    = "DenyWrongKMSKey"
    effect = "Deny"
    principals { 
      type = "*"
      identifiers = ["*"] 
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    condition { 
      test = "StringNotEquals" 
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values = [aws_kms_key.logging.arn] 
    }
  }
}

# Bucket permissions for CloudTrail delivery

data "aws_iam_policy_document" "bucket_cloudtrail_access" {
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals { 
      type = "Service"
      identifiers = ["cloudtrail.${data.aws_partition.current.dns_suffix}"] 
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition { 
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"] 
    }
  }

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals { 
      type = "Service"
      identifiers = ["cloudtrail.${data.aws_partition.current.dns_suffix}"] 
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs.arn]
  }
}

data "aws_iam_policy_document" "bucket_policy_combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.bucket_security.json,
    data.aws_iam_policy_document.bucket_cloudtrail_access.json
  ]
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.bucket_policy_combined.json
}

resource "aws_cloudtrail" "this" {
  name                          = "${local.name_base}-trail"
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  s3_bucket_name                = aws_s3_bucket.logs.id
  kms_key_id                    = aws_kms_key.logging.arn

  event_selector {
    read_write_type             = "All"
    include_management_events   = true
  }

  tags = var.tags

  depends_on = [aws_s3_bucket_policy.logs]
}
